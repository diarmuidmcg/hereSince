package com.diarmuiddevs.heresince.model

import com.diarmuiddevs.heresince.model.entity.Jar
import com.diarmuiddevs.heresince.model.entity.JarExtraInfo
import io.realm.kotlin.Realm
//import io.realm.kotlin.demo.model.entity.Jar
//import io.realm.kotlin.demo.util.Constants.MONGODB_REALM_APP_ID
//import io.realm.kotlin.demo.util.Constants.MONGODB_REALM_APP_PASSWORD
//import io.realm.kotlin.demo.util.Constants.MONGODB_REALM_APP_USER
import io.realm.kotlin.ext.query
import io.realm.kotlin.ext.realmListOf
import io.realm.kotlin.mongodb.*
import io.realm.kotlin.mongodb.sync.SyncConfiguration
import io.realm.kotlin.notifications.InitialResults
import io.realm.kotlin.notifications.ResultsChange
import io.realm.kotlin.query.RealmResults
import io.realm.kotlin.types.RealmList
import kotlinx.coroutines.*
import kotlinx.coroutines.flow.*

/**
 * Repository class. Responsible for storing the io.realm.kotlin.demo.model.entity.Jar and
 * expose updates to it.
 */

class JarRepository {

    private var realm: Realm
    private val app: App = App.create("heresincekotlin-mcafp")

    private var _jarStateFlow: MutableStateFlow<JarOverview> =
        MutableStateFlow(JarOverview(JARTYPE.NOTREGISTERED, jar = Jar()))
    private var _previousJars: MutableStateFlow<MutableList<Jar>> = MutableStateFlow(mutableListOf())


    constructor(realmD: Realm) {
        realm = realmD
//        maybe add jar subscription here?
//        realm.configuration.apply {
//            SyncConfiguration.Builder(app.currentUser!!, schema = setOf(Jar::class))
//                .initialSubscriptions { realm: Realm ->
//                    add(realm.query<Jar>())
//                }
//        }
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
     * Get user jars
     */
    fun findUserJars() :MutableList<Jar>{
//        return  realm.query<Jar>(query = "jarOwnerUserId == $0", app.currentUser?.id).find().asFlow()
//            .map {
//
//            }

        var userJars = mutableListOf<Jar>()
        val jars: RealmResults<Jar> = realm.query<Jar>(query = "jarOwnerUserId == $0", app.currentUser?.id).find()
        for(jar in jars) {
            println("jar: $jar")
            userJars.add(jar)
        }
        return userJars

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
    fun updateJarById(jarId: String, newJar: Jar, xtraInfo: List<JarExtraInfo>) {
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
                        if (app.currentUser?.id != null) jarOwnerUserId = app.currentUser?.id


                            if (xtraInfo != null) {
//                                need to set the input as realm list
                                val fields = realmListOf<JarExtraInfo>()
                                for (i in xtraInfo) {
                                    fields.add(
                                        JarExtraInfo(
                                            name = i.name,
                                            content = i.content,
                                            type = i.type
                                        )
                                    )
                                }
//                                store it in object
                                extraFields = fields
//                                newJar is passed as currentState flow, update that as well
                                newJar.extraFields = fields
                            }
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

    fun fetchJarOptions() : List<JarExtraInfo> {
        return listOf(
            JarExtraInfo(name = "Ingredients", content = "", type = "s"),
            JarExtraInfo(name = "Expiration Date", content = "", type = "d"),
            JarExtraInfo(name = "Caffeinated", content = "", type = "b"),
            JarExtraInfo(name = "Vegetarian", content = "", type = "b")
        )
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
