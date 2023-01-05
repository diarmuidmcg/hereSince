package com.diarmuiddevs.heresince.ui.jar

import CommonFlow
import CommonStateFlow
import asCommonFlow
import asCommonStateFlow
import com.diarmuiddevs.heresince.model.JarRepository
import com.diarmuiddevs.heresince.model.entity.Jar
import kotlinx.coroutines.flow.map


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
    private val repository = JarRepository()

    override fun observeCounter(): CommonFlow<String> {
        return repository.observeCounter()
            .map { count -> count.toString() }
            .asCommonFlow()
    }

    override fun observeWifiState(): CommonStateFlow<Boolean> {
        return repository.observeSyncConnection()
            .asCommonStateFlow()
    }

    override fun enableWifi() {
        repository.enableSync(true)
    }

    override fun disableWifi() {
        repository.enableSync(false)
    }

    override fun findJarById(jarId: String): Jar? {
        return repository.findJarById(jarId)
    }

    override fun increment() {
        repository.adjust(1)
    }

    override fun decrement() {
        repository.adjust(-1)
    }

}