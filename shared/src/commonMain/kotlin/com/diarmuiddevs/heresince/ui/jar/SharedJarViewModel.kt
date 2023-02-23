package com.diarmuiddevs.heresince.ui.jar

import CommonFlow
import CommonStateFlow
import asCommonFlow
import asCommonStateFlow
import com.diarmuiddevs.heresince.model.JarOverview
import com.diarmuiddevs.heresince.model.JarRepository
import com.diarmuiddevs.heresince.model.UserDetails
import com.diarmuiddevs.heresince.model.UserRepository
import com.diarmuiddevs.heresince.model.entity.Jar
import com.diarmuiddevs.heresince.model.entity.JarExtraInfo
import kotlinx.coroutines.flow.SharedFlow

/**
 * Class for the shared parts of the ViewModel.
 *
 * ViewModels are split into two parts:
 * - `SharedViewModel`, which contains the business logic and communication with
 *   the repository / model layer.
 * - `PlatformViewModel`, which is only a thin wrapper for hooking the SharedViewModel
 *   up to either SwiftUI (through `@ObservedObject`) or to Compose (though Flows).
 *
 * The boundary between these two classes must either be Flows or synchronous methods.
 * It is implemented with the assumption to always be called on the UI thread. This means
 * that all threading decisions are only implemented on the Kotlin Multiplatform side.
 *
 * This allows the UI to be fully tested by injecting a mocked ViewModel on the
 * platform side.
 */
class SharedJarViewModel: JarViewModel {
    // Implementation note: With a ViewModel this simple, just merging it with
    // Repository would probably be simpler, but by splitting the Repository
    // and ViewModel, we only need to enforce CommonFlows at the boundary, and
    // it means the CounterViewModel can be mocked easily in the View Layer.
    private val userRepository = UserRepository()
    lateinit private var jarRepository: JarRepository

    init {
        jarRepository = JarRepository(realmD = userRepository.realm)
    }

    override fun observeJarOverview(): CommonStateFlow<JarOverview> {
        return jarRepository.observeJarOverview()
            .asCommonStateFlow()
    }
    override fun observePrevJars(): CommonStateFlow<MutableList<Jar>> {
        return jarRepository.observePrevJars()
            .asCommonStateFlow()
    }

    override fun observeWifiState(): CommonStateFlow<Boolean> {
        return userRepository.observeSyncConnection()
            .asCommonStateFlow()
    }

    override  fun fetchJarOptions() : List<JarExtraInfo> {
        return jarRepository.fetchJarOptions()
    }

    override fun enableWifi() {
        userRepository.enableSync(true)
    }

    override fun disableWifi() {
        userRepository.enableSync(false)
    }

    override fun observeUserDetails(): CommonStateFlow<UserDetails> {
        return userRepository.observeUserDetails()
            .asCommonStateFlow()
    }

    override fun signOut() {
        return userRepository.signOut()
    }

    override fun userHasCreatedAcc() {
        userRepository.userHasCreatedAcc()
    }

    override fun signUserUpEmail(email: String, password:String) {
        userRepository.signUserUpEmail(email, password)
    }

    override fun signUserInEmail(email: String, password:String) {
        userRepository.signUserInEmail(email, password)
    }

    override fun findJarById(jarId: String) {
        jarRepository.findJarById(jarId)
    }
    override fun updateJarById(jarId: String, newJar: Jar, xtraInfo: List<JarExtraInfo>){
        jarRepository.updateJarById(jarId,newJar, xtraInfo)
    }

}