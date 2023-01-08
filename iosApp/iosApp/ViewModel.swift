//
//  ViewModel.swift
//  iosApp
//
//  Created by didi on 1/4/23.
//  Copyright © 2023 orgName. All rights reserved.
//

import Foundation

import Combine
import shared

// Generic Observable View Model, making it easier to control the lifecycle
// of multiple Flows.
class ObservableViewModel {
    private var jobs = Array<Closeable>() // List of Kotlin Coroutine Jobs
    func addObserver(observer: Closeable) {
        jobs.append(observer)
    }
    
    func stop() {
        jobs.forEach { job in job.close() }
    }
}

class IOSCounterViewModel: ObservableViewModel, ObservableObject {
    @Published var jar: String = "-"
    @Published var enabled: Bool = true
    @Published var currentJar: Jar = Jar()

    private let vm: SharedJarViewModel = SharedJarViewModel()
        
    override init() {
        super.init()
        start()
    }
    
    deinit {
        super.stop()
        vm.close()
    }
    
    func increment() {
        vm.increment()
    }

    func decrement() {
        vm.decrement()
    }
    
    func disableWifi() {
        vm.disableWifi()
    }
    
    func enableWifi() {
        vm.enableWifi()
    }
    func findJarById(jarId: String){
        vm.findJarById(jarId: jarId)
        
    }
    
    func getCurrentJar() -> Jar{
        return self.currentJar;
    }
   
    
    
    func start() {
        addObserver(observer: vm.observeJar().watch { jarValue in
            self.currentJar = jarValue! as Jar
            print("curr jar is " + self.currentJar._id)
        })
        addObserver(observer: vm.observeWifiState().watch { wifiEnabled in
            if (wifiEnabled!.boolValue) {
                self.enabled = true
            } else {
                self.enabled = false
            }
        })
    }
}
