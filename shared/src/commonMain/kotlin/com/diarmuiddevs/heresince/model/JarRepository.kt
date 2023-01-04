package com.diarmuiddevs.heresince.model

import com.diarmuiddevs.heresince.model.entity.Jar
import io.realm.kotlin.Realm
//import io.realm.kotlin.demo.model.entity.Jar
//import io.realm.kotlin.demo.util.Constants.MONGODB_REALM_APP_ID
//import io.realm.kotlin.demo.util.Constants.MONGODB_REALM_APP_PASSWORD
//import io.realm.kotlin.demo.util.Constants.MONGODB_REALM_APP_USER
import io.realm.kotlin.ext.query
import io.realm.kotlin.internal.platform.runBlocking
import io.realm.kotlin.mongodb.App
import io.realm.kotlin.mongodb.Credentials
import io.realm.kotlin.mongodb.subscriptions
import io.realm.kotlin.mongodb.sync.SyncConfiguration
import io.realm.kotlin.mongodb.syncSession
import io.realm.kotlin.notifications.SingleQueryChange
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.launch

/**
 * Repository class. Responsible for storing the io.realm.kotlin.demo.model.entity.Counter and
 * expose updates to it.
 */
class JarRepository {

    private var realm: Realm
    private val app: App = App.create("heresincekotlin-mcafp")
    private var syncEnabled: MutableStateFlow<Boolean> = MutableStateFlow(true)
    lateinit var currentJar: Jar

    init {
        // It is bad practise to use runBlocking here. Instead we should have a dedicated login
        // screen that can also prepare the Realm after login. Doing it here is just for simplicity.
        realm = runBlocking {
            // Log in user and open a synchronized Realm for that user.
            val user = app.login(Credentials.anonymous(reuseExisting = true))
            val config = SyncConfiguration.Builder(schema = setOf(Jar::class), user = user)
                .initialSubscriptions { realm: Realm ->
                    // We only subscribe to a single object.
                    // The Counter object will have the _id of the user.
                    findByQuery(realm.query<Jar>("jarOwnerUserId = $0", user.id))
                }
                .initialData {
                    // Create the initial counter object if needed. This allow the Realm to be
                    // opened and used while the device is offline.
                    // If the server already has an object, they will be merged.
//                    copyToRealm(Jar(user.id))
                }
                .build()
            Realm.open(config)
        }
    }

    /**
     * Adjust the counter up and down.
     */
    fun findJarById(jarId: String) {
        CoroutineScope(Dispatchers.Default).launch {
//            realm.apply {
                println("jar id is " + jarId)
                realm.query<Jar>("jarId = $0", jarId).first().find()?.apply {
                    println("am i ever called?")
                    currentJar = return@apply
                    println("jar id is " + currentJar.toString())
                }

            }
//        }
    }

    /**
     * Adjust the counter up and down.
     */
    fun adjust(change: Int) {
        CoroutineScope(Dispatchers.Default).launch {
            realm.write {
                val userId = app.currentUser?.id ?: throw IllegalStateException("No user found")
                query<Jar>("_id = $0", userId).first().find()?.run {
                    value.increment(change)
                } ?: println("Could not update io.realm.kotlin.demo.model.entity.Counter")
            }
        }
    }

    /**
     * Listen to changes to the counter.
     */
    fun observeCounter(): Flow<Long> {
        val userId = app.currentUser?.id ?: throw IllegalStateException("No user found")
        return realm.query<Jar>("_id = $0", userId).first().asFlow()
            .map { change: SingleQueryChange<Jar> ->
                change.obj?.value?.toLong() ?: 0
            }
    }

    fun observeSyncConnection(): StateFlow<Boolean> {
        return syncEnabled
    }

    fun enableSync(enabled: Boolean) {
        when(enabled) {
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