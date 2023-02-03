package com.diarmuiddevs.heresince.model

import com.diarmuiddevs.heresince.model.entity.DataTypes
import com.diarmuiddevs.heresince.model.entity.Jar
import com.diarmuiddevs.heresince.model.entity.JarAdditionalInfo
import io.realm.kotlin.Realm
import io.realm.kotlin.RealmConfiguration
import io.realm.kotlin.exceptions.RealmException
//import io.realm.kotlin.demo.model.entity.Jar
//import io.realm.kotlin.demo.util.Constants.MONGODB_REALM_APP_ID
//import io.realm.kotlin.demo.util.Constants.MONGODB_REALM_APP_PASSWORD
//import io.realm.kotlin.demo.util.Constants.MONGODB_REALM_APP_USER
import io.realm.kotlin.ext.query
import io.realm.kotlin.internal.platform.runBlocking
import io.realm.kotlin.mongodb.*
import io.realm.kotlin.mongodb.exceptions.*
import io.realm.kotlin.mongodb.sync.SyncConfiguration
import io.realm.kotlin.notifications.InitialResults
import io.realm.kotlin.notifications.ResultsChange
import io.realm.kotlin.query.RealmResults
import kotlinx.coroutines.*
import kotlinx.coroutines.flow.*

/**
 * Repository class. Responsible for storing the io.realm.kotlin.demo.model.entity.Jar and
 * expose updates to it.
 */



open class UserDetails {
    var hasAccount : Boolean = false
    var userJars : MutableList<Jar> = mutableListOf()
    var user : io.realm.kotlin.mongodb.User? = null
    var error :RealmException = RealmException()
    constructor()  {
    } // Empty constructor for Realm
    constructor(copyUserD: UserDetails) {
        hasAccount = copyUserD.hasAccount
        userJars = copyUserD.userJars
        user = copyUserD.user
        error = copyUserD.error

    }

    fun showErrorText() : String{
        return when (error) {
            is InvalidCredentialsException -> "Invalid Username or Password"
            is AppException -> "There was a back-end issue"
            else -> {
                "There was an Error"
            }
        }
    }
}

class JarRepository {

    private var realm: Realm
    private val app: App = App.create("heresincekotlin-mcafp")

    private var syncEnabled: MutableStateFlow<Boolean> = MutableStateFlow(true)
    private var _jarStateFlow: MutableStateFlow<JarOverview> =
        MutableStateFlow(JarOverview(JARTYPE.NOTREGISTERED, jar = Jar()))
    private var _previousJars: MutableStateFlow<MutableList<Jar>> = MutableStateFlow(mutableListOf())

    private var _userDetails: MutableStateFlow<UserDetails> = MutableStateFlow(UserDetails())

    lateinit var user : io.realm.kotlin.mongodb.User

    init {
//        set up the realm on app launch
        realm = runBlocking {
            // Log in user and open a synchronized Realm for that user.
//    check if there exists a user -> otherwise use anon


            _userDetails.value.user = if (app.currentUser == null) {
                app.login(Credentials.anonymous(reuseExisting = true))
            } else app.currentUser!!


            val config = SyncConfiguration.Builder(_userDetails.value.user!!, schema = setOf(Jar::class))
                .initialSubscriptions { realm: Realm ->
                    add(realm.query<Jar>())
                }
                .build()
            Realm.open(config)

//            val configuration = RealmConfiguration.create(schema = setOf(Jar::class))
//            Realm.open(configuration)

        }
        userHasCreatedAcc()
        findAllJars()
    }

//    }

    /**
     * Associate a user w an email & password
     */
    fun signUserUpEmail(email: String, password: String) {
        CoroutineScope(Dispatchers.Default).launch { // wrap in coroutine
            async { // wrap on async call
                try { // wrap try catch to avoid nothing being returned
                    // registers an email/password user
                    app.emailPasswordAuth.registerUser(email, password)
                    // links anonymous user with email/password credentials
                    _userDetails.value.user?.linkCredentials(Credentials.emailPassword(email, password));
//                    set custom data
                    _userDetails.value.hasAccount = true
                } catch (e: AppException) {
//
                    _userDetails.value.error = e
                }
            }
        }
    }

    /**
     * Associate a user w an email & password
     */
    fun signUserInEmail(email: String, password: String) {
        CoroutineScope(Dispatchers.Default).launch { // wrap in coroutine
            async { // wrap on async call
                try { // wrap try catch to avoid nothing being returned
//                  make query getting first (& only) jar w given jarId
                    _userDetails.value.user = app.login(Credentials.emailPassword(email,password))

//                    println("signed user in " + _userDetails.value.user.id)
                    _userDetails.value.hasAccount = true
                } catch (e: AppException) {
//
                    println("error signing user in $e")


                    val newUserD = UserDetails(_userDetails.value)
                    newUserD.error = e
//                    _userDetails.apply {
                        _userDetails.value = newUserD
//                    }
                }
            }
        }
    }

    /**
     * Associate a user w an email & password
     */
    fun signOut() {
        CoroutineScope(Dispatchers.Default).launch { // wrap in coroutine
            async { // wrap on async call
                try { // wrap try catch to avoid nothing being returned
//                  log user out
                    _userDetails.value.user?.logOut()
                    _userDetails.value.hasAccount = false
//                    create a new anon user to use sync
                    _userDetails.value.user = app.login(Credentials.anonymous(reuseExisting = true))
//                    reset prev & user jars
                    _previousJars.update {
                        _previousJars.value.toMutableList().apply { this.clear()}
                    }
                    _userDetails.update {
                        _userDetails.value.apply { this.userJars.clear()}
                    }
                } catch (e: AppException) {
//
                    _userDetails.value.error = e
                }
            }
        }
    }
    /**
     * small func to determine if user has set up account instead of anon
     */
    fun userHasCreatedAcc()  {
        println("checking if has acc " + _userDetails.value.user?.identities?.count().toString())
//        any user will default 1 auth identifty (anon). If they add another (email, apple, etc), they will have more than 1
        _userDetails.value.hasAccount = _userDetails.value.user?.identities?.count()!! > 1
    }

    /**
     * Get a jar by its Id
     */
    fun findJarById(jarId: String) {
        CoroutineScope(Dispatchers.Default).launch { // wrap in coroutine
            async { // wrap on async call
                try { // wrap try catch to avoid nothing being returned
//                  make query getting first (& only) jar w given jarId
                    var jar = realm.query<Jar>(query = "_id == $0", jarId).find().first()
                    realm.write { // set stateflow for observer to update
//                        set the current jar to the JarOverview (includes type)
                        _jarStateFlow.value = determineJarDetails(jar)
//                        if the jar has data, make sure its not already a previous jar & add it
                        if (_jarStateFlow.value.type == JARTYPE.JARHASDATA) {
                            if (!_previousJars.value.any{ it._id == jar._id}) {
//                                verbose bc just adding item to mutableList will not update state flow
                                _previousJars.update {
                                    _previousJars.value.toMutableList().apply { this.add(jar) }
                                }
                            }
                        }
                    }
                } catch (e: NoSuchElementException) {
                    println("jar dont exist? " + jarId)
//                    if does not exist, set JARTYPE to not reg
                    _jarStateFlow.value = JarOverview(type = JARTYPE.NOTREGISTERED, jar = Jar())
                }
            }
        }
    }



    /**
     * Adjust the counter up and down.
     */
    fun findAllJars() {
        CoroutineScope(Dispatchers.Default).launch {
            val frogsFlow: Flow<ResultsChange<Jar>> = realm.query<Jar>().asFlow()
            val asyncCall: Deferred<Unit> = async {
                frogsFlow.collect { results ->
                    when (results) {
                        // print out initial results
                        is InitialResults<Jar> -> {
                            for (frog in results.list) {
                                println("Frog: ${frog.extraInfo}")
                            }
                        }
                        else -> {
                            // do nothing on changes
                        }
                    }
                }
            }

        }
    }

    /**
     * Get a jar by its Id
     */
    fun updateJarById(jarId: String, newJar: Jar, xtraInfo: List<JarAdditionalInfo>) {
        print("finding jar at " + jarId)
        CoroutineScope(Dispatchers.Default).launch { // wrap in coroutine

                try { // wrap try catch to avoid nothing being returned
//                  make query getting first (& only) jar w given jarId
                    var jar = realm.query<Jar>(query = "_id == $0", jarId).find().first()
                    realm.writeBlocking {
                        findLatest(jar)?.apply {
                            if (newJar.jarContentName != "") jarContentName = newJar.jarContentName
                            if (newJar.hereSince != "") hereSince = newJar.hereSince
                            if (newJar.jarOwnerName != "") jarOwnerName = newJar.jarOwnerName
                            jarOwnerUserId = _userDetails.value.user?.id
//                            if (newJar.additionalInfo != null) additionalInfo = newJar.additionalInfo
//                            for (i in xtraInfo.toMutableList()) {
//                                println("mutable list is " + i.name + " " + i.content)
//                            }
//                            additionalInfo.add(JarAdditionalInfo(name = "test", content = "test", type = DataTypes.STRING))
//                            extraInfo.add(JarAdditionalInfo(name = "test", content = "test", type = DataTypes.STRING))
                        }
                    }
                    //                        set the current jar to the JarOverview (includes type)
//                    realm.writeBlocking {
                        _jarStateFlow.update {
                            determineJarDetails(newJar)
                        }
//                    }

                } catch (e: NoSuchElementException) {
                    print("did not find jar")
//                    if does not exist, set JARTYPE to not reg
                    _jarStateFlow.value = JarOverview(type = JARTYPE.NOTREGISTERED, jar = Jar())
                }

        }
    }

    /**
     * Adjust the counter up and down.
     */
    fun adjust(change: Int) {
        CoroutineScope(Dispatchers.Default).launch {
            realm.write {
                val userId = app.currentUser?.id ?: throw IllegalStateException("No user found")
                query<Jar>("_id = $0", userId).first().find()?.run {
//                    value.increment(change)
                } ?: println("Could not update io.realm.kotlin.demo.model.entity.Counter")
            }
        }
    }
    /**
     * Listen to changes to the counter.
     */
    fun observeJarOverview(): StateFlow<JarOverview> {
        println("observing jar")
        return _jarStateFlow
    }
    fun observePrevJars(): StateFlow<MutableList<Jar>> {
        println("observing prev jar")
        return _previousJars
    }
    fun observeUserDetails(): StateFlow<UserDetails> {
        println("observing user details")
        return _userDetails
    }


    fun observeSyncConnection(): StateFlow<Boolean> {
        return syncEnabled
    }

    fun enableSync(enabled: Boolean) {
        when (enabled) {
            false -> {
                realm.syncSession.pause()
                syncEnabled.value = false
            }
            true -> {
                realm.syncSession.resume()
                syncEnabled.value = true
            }
        }
    }

    fun determineJarDetails(jar: Jar): JarOverview {
        println("determing jar ")
        //        return readTagResponse
        return if (jar == null) JarOverview(JARTYPE.NOTREGISTERED,Jar())
        else if (jar.jarContentName == "") JarOverview(type = JARTYPE.JARNODATA, jar = jar)
        else JarOverview(type = JARTYPE.JARHASDATA, jar = jar)
    }
}

// this all may be used on backend too, will determine
enum class JARTYPE { JARHASDATA,JARNODATA,NOTREGISTERED}

open class JarOverview(
    val type: JARTYPE,
    val jar: Jar
)
