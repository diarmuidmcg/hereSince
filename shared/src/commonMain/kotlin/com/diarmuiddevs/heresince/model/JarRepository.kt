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
import io.realm.kotlin.mongodb.sync.SyncConfiguration
import io.realm.kotlin.notifications.InitialResults
import io.realm.kotlin.notifications.ResultsChange
import io.realm.kotlin.query.RealmResults
import kotlinx.coroutines.*
import kotlinx.coroutines.flow.*
import kotlin.coroutines.suspendCoroutine

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
    private var _previousJars: MutableStateFlow<MutableList<Jar>> =
        MutableStateFlow(mutableListOf())
    private var _userJars: MutableStateFlow<MutableList<Jar>> =
        MutableStateFlow(mutableListOf())

    init {
//        set up the realm on app launch
        realm = runBlocking {
            // Log in user and open a synchronized Realm for that user.
//            val user = app.login(Credentials.anonymous(reuseExisting = true))
//            val config = SyncConfiguration.Builder(user, schema = setOf(Jar::class))
//                .initialSubscriptions { realm: Realm ->
//                    add(realm.query<Jar>())
//                }
//                .build()
//            Realm.open(config)

            val configuration = RealmConfiguration.create(schema = setOf(Jar::class))
            Realm.open(configuration)

        }
    }

//    }

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
                            if (jar !in  _previousJars.value) _previousJars.value.add(jar)
                        }
                    }
                } catch (e: NoSuchElementException) {
//                    if does not exist, set JARTYPE to not reg
                    _jarStateFlow.value = JarOverview(type = JARTYPE.NOTREGISTERED, jar = Jar())
                }
            }
        }
    }


    fun getJar(jarId: String) {
        println("looking for " + jarId)
        CoroutineScope(Dispatchers.Default).launch {
            val singleJarFlow: Flow<ResultsChange<Jar>> =
                realm.query<Jar>(query = "_id == $0", jarId).asFlow()
            val asyncCall: Deferred<Unit> = async {
                singleJarFlow.collect { results ->
                    when (results) {
                        // print out initial results
                        is InitialResults<Jar> -> {
                            for (jar in results.list) {
                                realm.write {
                                    val newInfo1 =
                                        JarAdditionalInfo("Description", "I got this last year!")
                                    jar.additionalInfo.add(newInfo1)
                                    val newInfo =
                                        JarAdditionalInfo("ingredients", "Corn syrup, sugar")
                                    jar.additionalInfo.add(newInfo)
                                    val newInfo2 = JarAdditionalInfo("Story", "Made with love!")
                                    jar.additionalInfo.add(newInfo2)
                                    _jarStateFlow.value = determineJarDetails(jar)
                                }
                            }
                        }
                        else -> {

                            // do nothing on changes
                        }

                    }
                }


            }


            singleJarFlow.onEmpty { println("i am epty") }
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
        //        return readTagResponse
        return if (jar == null) JarOverview(JARTYPE.NOTREGISTERED,Jar())
        else if (jar.jarContentName == "") JarOverview(type = JARTYPE.JARNODATA, jar = Jar())
        else JarOverview(type = JARTYPE.JARHASDATA, jar = jar)
    }
}

// this all may be used on backend too, will determine
enum class JARTYPE { JARHASDATA,JARNODATA,NOTREGISTERED}

open class JarOverview(
    val type: JARTYPE,
    val jar: Jar
)
