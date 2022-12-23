package com.diarmuiddevs.heresince

class CoreUserAttributes {
    var hasAccount = false;
    var hasTags = true;
    var userId = "look its me ";



    fun determineUserPrefs() {
        hasAccount = false;
        hasTags = false;
        userId = "myUserId";
    }
}