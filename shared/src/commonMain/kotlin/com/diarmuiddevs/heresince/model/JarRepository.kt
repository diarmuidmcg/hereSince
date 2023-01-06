package com.diarmuiddevs.heresince.model

import com.diarmuiddevs.heresince.model.entity.Jar
import io.realm.kotlin.Realm
import io.realm.kotlin.RealmConfiguration
import io.realm.kotlin.ext.asFlow
//import io.realm.kotlin.demo.model.entity.Jar
//import io.realm.kotlin.demo.util.Constants.MONGODB_REALM_APP_ID
//import io.realm.kotlin.demo.util.Constants.MONGODB_REALM_APP_PASSWORD
//import io.realm.kotlin.demo.util.Constants.MONGODB_REALM_APP_USER
import io.realm.kotlin.ext.query
import io.realm.kotlin.internal.platform.runBlocking
import io.realm.kotlin.mongodb.*
import io.realm.kotlin.mongodb.sync.SyncConfiguration
import io.realm.kotlin.notifications.ObjectChange
import io.realm.kotlin.notifications.SingleQueryChange
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.*
import kotlinx.coroutines.launch

/**
 * Repository class. Responsible for storing the io.realm.kotlin.demo.model.entity.Counter and
 * expose updates to it.
 */

class JarRepository {

    private var realm: Realm
    private val app: App = App.create("heresincekotlin-mcafp")



    private var syncEnabled: MutableStateFlow<Boolean> = MutableStateFlow(true)

    private val _currJarStateFlow = MutableStateFlow(Jar("test"))
    val currJarSF = _currJarStateFlow.asStateFlow()

    init {
        // It is bad practise to use runBlocking here. Instead we should have a dedicated login
        // screen that can also prepare the Realm after login. Doing it here is just for simplicity.
//        realm = runBlocking {
//            // Log in user and open a synchronized Realm for that user.
//            val user = app.login(Credentials.anonymous(reuseExisting = true))
//
//            val config = SyncConfiguration.Builder(schema = setOf(Jar::class), user = user)
//                .build()
//            Realm.open(config)
//        }
        val config = RealmConfiguration.Builder(
            schema = setOf(Jar::class)
        ).build()

        // Open Realm
        realm = Realm.open(config)

    }

    /**
     * Adjust the counter up and down.
     */
    fun findJarById(jarId: String) {
        println("looking for " + jarId)
        CoroutineScope(Dispatchers.Default).launch {
            _currJarStateFlow.value = realm.query<Jar>().first().find() ?: Jar("testId")
            println("got jar of " + _currJarStateFlow.value._id)
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
//    fun observeCounter(): Flow<Long> {
//        val userId = app.currentUser?.id ?: throw IllegalStateException("No user found")
//        return realm.query<Jar>("_id = $0", userId).first().asFlow()
//            .map { change: SingleQueryChange<Jar> ->
////                change.obj?.value?.toLong() ?: 0
//            }
//    }

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