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

class User {
//    private var realm: Realm
    private val app: App = App.create("heresincekotlin-mcafp")


    private var syncEnabled: MutableStateFlow<Boolean> = MutableStateFlow(true)
    private var _jarStateFlow: MutableStateFlow<JarOverview> =
        MutableStateFlow(JarOverview(JARTYPE.NOTREGISTERED, jar = Jar()))

    init {
//        set up the realm on app launch
//        realm = runBlocking {
////             Log in user and open a synchronized Realm for that user.
////            val user = app.login(Credentials.anonymous(reuseExisting = true))
//
//
//        }
    }

//    }

    /**
     * Get a jar by its Id
     */
    fun signInByEmail(email: String, password: String) {
        CoroutineScope(Dispatchers.Default).launch { // wrap in coroutine
          app.login(Credentials.emailPassword(email,password))
        }
    }

}


