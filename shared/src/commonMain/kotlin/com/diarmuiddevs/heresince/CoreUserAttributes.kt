package com.diarmuiddevs.heresince

class CoreUserAttributes {
    var hasAccount = false;
    var hasTags = true;
    var userId = "look its me ";
    var userEmail = "diarmuiddevs@proton.me";
    var userDisplayName = "Diarmuid";



    fun determineUserPrefs() {
        hasAccount = false;
        hasTags = false;
        userId = "myUserId";
    }
}