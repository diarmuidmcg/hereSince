package com.diarmuiddevs.heresince.model

import com.diarmuiddevs.heresince.model.entity.Jar
import com.diarmuiddevs.heresince.model.entity.JarAdditionalInfo
import io.realm.kotlin.Realm
import io.realm.kotlin.RealmConfiguration
//import io.realm.kotlin.demo.model.entity.Jar
//import io.realm.kotlin.demo.util.Constants.MONGODB_REALM_APP_ID
//import io.realm.kotlin.demo.util.Constants.MONGODB_REALM_APP_PASSWORD
//import io.realm.kotlin.demo.util.Constants.MONGODB_REALM_APP_USER
import io.realm.kotlin.ext.query
import io.realm.kotlin.internal.platform.runBlocking
import io.realm.kotlin.mongodb.*
import io.realm.kotlin.mongodb.exceptions.AppException
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

class JarRepository {

    private var realm: Realm
    private val app: App = App.create("heresincekotlin-mcafp")


    private var syncEnabled: MutableStateFlow<Boolean> = MutableStateFlow(true)
    private var _jarStateFlow: MutableStateFlow<JarOverview> =
        MutableStateFlow(JarOverview(JARTYPE.NOTREGISTERED, jar = Jar()))
    private var _previousJars: MutableStateFlow<MutableList<Jar>> = MutableStateFlow(mutableListOf())
    private var _userJars: MutableStateFlow<MutableList<Jar>> =
        MutableStateFlow(mutableListOf())

    private var _hasAccount: MutableStateFlow<Boolean> = MutableStateFlow(false)
    lateinit var user : io.realm.kotlin.mongodb.User

    init {
//        set up the realm on app launch
        realm = runBlocking {
            // Log in user and open a synchronized Realm for that user.
//            if has api or json stored -> use that
            println("runs on launch")
//            else use credentials
            user = app.login(Credentials.anonymous(reuseExisting = true))
            val config = SyncConfiguration.Builder(user, schema = setOf(Jar::class))
                .initialSubscriptions { realm: Realm ->
                    add(realm.query<Jar>())
                }
                .build()
            Realm.open(config)

//            val configuration = RealmConfiguration.create(schema = setOf(Jar::class))
//            Realm.open(configuration)

        }
        println("user id " + user.id)
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
                    user.linkCredentials(Credentials.emailPassword(email, password));
//                    set custom data
                    _hasAccount.value = true
                } catch (e: AppException) {
//
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
                    user = app.login(Credentials.emailPassword(email,password))

                    println("signed user in " + user.id)
                    _hasAccount.value = true
                } catch (e: AppException) {
//
                    println("error signing user in $e")
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
                    user.logOut()
                    _hasAccount.value = false
//                    create a new anon user to use sync
                    user = app.login(Credentials.anonymous(reuseExisting = true))
//                    reset prev & user jars
                    _previousJars.update {
                        _previousJars.value.toMutableList().apply { this.clear()}
                    }
                    _userJars.update {
                        _userJars.value.toMutableList().apply { this.clear()}
                    }
                } catch (e: AppException) {
//
                }
            }
        }
    }
    /**
     * small func to determine if user has set up account instead of anon
     */
    fun userHasCreatedAcc()  {
        println("checking if has acc " + user.identities.count().toString())
//        any user will default 1 auth identifty (anon). If they add another (email, apple, etc), they will have more than 1
        _hasAccount.value = user.identities.count() > 1
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
                                println("Frog: ${frog._id}")
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
    fun updateJarById(jarId: String, newJar: Jar) {
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
                            jarOwnerUserId = user.id
                            if (newJar.additionalInfo != null) additionalInfo = newJar.additionalInfo
                            if (newJar.extraInfo != null) extraInfo = newJar.extraInfo
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
    fun observeUserJars(): StateFlow<MutableList<Jar>> {
        println("observing user  jars")
        return _userJars
    }
    fun observeHasAccount(): StateFlow<Boolean> {
        println("observing has  acc")
        return _hasAccount
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
