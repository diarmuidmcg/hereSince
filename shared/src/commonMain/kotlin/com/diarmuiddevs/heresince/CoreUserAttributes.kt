package com.diarmuiddevs.heresince

import io.realm.kotlin.mongodb.App
import io.realm.kotlin.mongodb.Credentials
import kotlinx.coroutines.runBlocking


class CoreUserAttributes {
    var hasAccount = false;
    var hasTags = true;
    var userId = "look its me ";
    var userEmail = "diarmuiddevs@proton.me";
    var userDisplayName = "Diarmuid";


    lateinit var user: io.realm.kotlin.mongodb.User
//    val app = App.create("heresincekotlin-mcafp");
    init {
//        // It is bad practise to use runBlocking here. Instead we should have a dedicated login
//        // screen that can also prepare the Realm after login. Doing it here is just for simplicity.
        runBlocking {
//            val app = App.create("heresincekotlin-mcafp");
//            // Log in user and open a synchronized Realm for that user.
//            user = app.login(Credentials.anonymous(reuseExisting = true))
        }
    }

    fun determineUserPrefs() {
        hasAccount = false;
        hasTags = false;
        userId = "myUserId";
    }
}