package com.diarmuiddevs.heresince.model

import com.diarmuiddevs.heresince.model.entity.Jar
import com.diarmuiddevs.heresince.model.entity.JarAdditionalInfo
import io.realm.kotlin.Realm
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
    var error : RealmException = RealmException()
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
            is UserAlreadyExistsException -> "There already exists a user with this profile"
            else -> ({
                error.message
            }).toString()
        }
    }
}

class UserRepository {

    var realm: Realm
    private val app: App = App.create("heresincekotlin-mcafp")

    private var syncEnabled: MutableStateFlow<Boolean> = MutableStateFlow(true)

    private var _userDetails: MutableStateFlow<UserDetails> = MutableStateFlow(UserDetails())

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
                    //                    need to copy & create new UserDetails to update mutable state flow before saving
                    val newUserD = UserDetails(_userDetails.value)
                    // links anonymous user with email/password credentials
                    newUserD.user?.linkCredentials(Credentials.emailPassword(email, password));
                    newUserD.hasAccount = true
                    _userDetails.value = newUserD
                } catch (e: AppException) {
                    println("error signing user up $e")
//                    need to copy & create new UserDetails to update mutable state flow before saving
                    val newUserD = UserDetails(_userDetails.value)
                    newUserD.error = e
                    newUserD.hasAccount = false
                    _userDetails.value = newUserD
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

                    //                    need to copy & create new UserDetails to update mutable state flow before saving
                    val newUserD = UserDetails(_userDetails.value)
                    newUserD.user = app.login(Credentials.emailPassword(email,password))
                    newUserD.hasAccount = true
                    _userDetails.value = newUserD
                } catch (e: AppException) {
                    println("error signing user in $e")
//                    need to copy & create new UserDetails to update mutable state flow before saving
                    val newUserD = UserDetails(_userDetails.value)
                    newUserD.error = e
                    newUserD.hasAccount = false
                    _userDetails.value = newUserD
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
                    val newUserD = UserDetails(_userDetails.value)
//                  log user out
                    newUserD.user?.logOut()
                    newUserD.hasAccount = false
//                    create a new anon user to use sync
                    newUserD.user = app.login(Credentials.anonymous(reuseExisting = true))
//                    reset prev & user jars
                    newUserD.userJars.clear()
                    _userDetails.value = newUserD


                } catch (e: AppException) {
                    println("error signing user out $e")
//                    need to copy & create new UserDetails to update mutable state flow before saving
                    val newUserD = UserDetails(_userDetails.value)
                    newUserD.error = e
                    _userDetails.value = newUserD
                }
            }
        }
    }
    /**
     * small func to determine if user has set up account instead of anon
     */
    fun userHasCreatedAcc()  {
        println("checking if has acc " + _userDetails.value.user?.identities?.count().toString())
        val newUserD = UserDetails(_userDetails.value)
//        any user will default 1 auth identifty (anon). If they add another (email, apple, etc), they will have more than 1
        newUserD.hasAccount = newUserD.user?.identities?.count()!! > 1
        _userDetails.value = newUserD
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
}
