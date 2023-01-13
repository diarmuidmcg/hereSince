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
    @Published var loadingJar: Bool = false
    @Published var launchModal: Bool = false
    @Published var enabled: Bool = true
    @Published var currJar: JarOverview = JarOverview(type: JARTYPE.notregistered, jar: Jar())
//    store additional info in this bc SwiftUI ForEach can iterate a set, not a
//    MutableKotlinSet because that does not implement Hashable
    @Published var currentAddInfo: Set<JarAdditionalInfo> = Set<JarAdditionalInfo>()
    @Published var prevJars: Array<Jar> = Array<Jar>()
    @Published var userJars: Array<Jar> = Array<Jar>()
    

    private let vm: SharedJarViewModel = SharedJarViewModel()
        
    override init() {
        super.init()
        start()
    }
    
    deinit {
        super.stop()
        vm.close()
    }
    
    func disableWifi() {
        vm.disableWifi()
    }
    
    func enableWifi() {
        vm.enableWifi()
    }
    func findJarById(jarId: String){
        self.launchModal = true
        vm.findJarById(jarId: jarId)
    }
    
       
    
    func start() {
        addObserver(observer: vm.observeJarOverview().watch { jarOverviewValue in
            self.currJar = jarOverviewValue! as JarOverview
            if (self.currJar.type == JARTYPE.jarhasdata) {
                self.currentAddInfo = self.currJar.jar.additionalInfo as! Set<JarAdditionalInfo>
                print("curr jar O is " + self.currJar.jar._id)
            }
            self.loadingJar = false
        })
//        addObserver(observer: vm.observePrevJars().watch { prevJarsList in
//            self.prevJars = prevJarsList! as Array<Jar>
//        })
//        addObserver(observer: vm.observeUserJars().watch { jarList in
////            self.userJars = jarList! as Array<Jar>
//        })
        addObserver(observer: vm.observeWifiState().watch { wifiEnabled in
            if (wifiEnabled!.boolValue) {
                self.enabled = true
            } else {
                self.enabled = false
            }
        })
    }
}

// extension so JarAdditionalInfo can be iterated thru a SwiftUI Foreach
extension JarAdditionalInfo:Comparable {
    public static func < (lhs: JarAdditionalInfo, rhs: JarAdditionalInfo) -> Bool {
//       so ingredients always first
        if (rhs.name.uppercased() == "INGREDIENTS") {return false}
        else {return true}
    }
}

