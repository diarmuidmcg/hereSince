package com.diarmuiddevs.heresince.ui.jar

import CommonFlow
import CommonStateFlow
import com.diarmuiddevs.heresince.model.JarOverview
import com.diarmuiddevs.heresince.model.UserDetails
import com.diarmuiddevs.heresince.model.entity.Jar
import com.diarmuiddevs.heresince.model.entity.JarExtraInfo
import io.realm.kotlin.mongodb.User
import kotlinx.coroutines.CoroutineName
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.cancel
import kotlinx.coroutines.flow.SharedFlow
import kotlinx.coroutines.flow.StateFlow


interface JarViewModel: SharedViewModel {
    fun observeJarOverview(): CommonStateFlow<JarOverview>
    fun observePrevJars(): CommonStateFlow<MutableList<Jar>>
    fun signUserUpEmail(email: String, password:String)
    fun signUserInEmail(email: String, password:String)
    fun signOut()
    fun deleteAccount()
    fun fetchJarOptions() : List<JarExtraInfo>
//    may not export this
    fun userHasCreatedAcc()
    fun observeUserDetails(): CommonStateFlow<UserDetails>


    fun observeWifiState(): CommonStateFlow<Boolean>
    fun enableWifi()
    fun disableWifi()
    fun findJarById(jarId: String)
    fun updateJarById(jarId: String, newJar: Jar, xtraInfo: List<JarExtraInfo>)
}

interface SharedViewModel {

    // Instead of using e.g. `viewModelScope` from Android, we construct our own.
    // This way, the scope is shared between iOS and Android and its lifecycle
    // is controlled the same way.
    val scope
        get() = CoroutineScope(CoroutineName(""))

    /**
     * Cancels the current scope and any jobs in it.
     * This should be called by the UI when it no longer need the
     * ViewModel.
     */
    fun close() {
        scope.cancel()
    }
}