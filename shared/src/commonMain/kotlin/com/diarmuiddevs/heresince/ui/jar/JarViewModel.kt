package com.diarmuiddevs.heresince.ui.jar

import CommonFlow
import CommonStateFlow
import com.diarmuiddevs.heresince.model.JarOverview
import com.diarmuiddevs.heresince.model.entity.Jar
import kotlinx.coroutines.CoroutineName
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.cancel


interface JarViewModel: SharedViewModel {
    fun observeJarOverview(): CommonStateFlow<JarOverview>
    fun observePrevJars(): CommonStateFlow<MutableList<Jar>>
    fun observeUserJars(): CommonStateFlow<MutableList<Jar>>
    fun signUserUpEmail(email: String, password:String)
    fun signUserInEmail(email: String, password:String)

    fun observeWifiState(): CommonStateFlow<Boolean>
    fun enableWifi()
    fun disableWifi()
    fun findJarById(jarId: String)
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