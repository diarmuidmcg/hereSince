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
    @Published var currentJar: Jar = Jar()
    @Published var currentJarOverview: JarOverview = JarOverview(type: JARTYPE.notregistered, jar: Jar())
    @Published var currentAddInfo: Set<JarAdditionalInfo> = Set<JarAdditionalInfo>()

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
            self.currentAddInfo = self.currentJar.additionalInfo as! Set<JarAdditionalInfo>
            print("curr jar is " + self.currentJar._id)
        })
        addObserver(observer: vm.observeJarOverview().watch { jarOverviewValue in
            self.currentJarOverview = jarOverviewValue! as JarOverview

            if (self.currentJarOverview.type == JARTYPE.jarhasdata) {
                self.currentAddInfo = self.currentJarOverview.jar.additionalInfo as! Set<JarAdditionalInfo>
                print("curr jar O is " + self.currentJarOverview.jar._id)
            }
            
            self.loadingJar = false

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

extension JarAdditionalInfo:Comparable {
    public static func < (lhs: JarAdditionalInfo, rhs: JarAdditionalInfo) -> Bool {
//        imp so ingredients always first?
        if (rhs.name.uppercased() == "INGREDIENTS") {return false}
        else {return true}
    }
}

// create extension of JarAdditionalInfo that implements Comparable so it can be
// used in ForEach loops
//class JarAddInfo: JarAdditionalInfo, Comparable {
////    minimum comparable method to implement
//    static func < (lhs: JarAddInfo, rhs: JarAddInfo) -> Bool {
////        imp so ingredients always first?
//        if (rhs.infoName.uppercased() == "INGREDIENTS") {return false}
//        else {return true}
//    }
//    var infoName: String
//    var infoContent: String
//    public init(_ obj: JarAdditionalInfo) {
//        self.infoName = obj.name
//        self.infoContent = obj.content
//        super.init()
//    }
//
//
//}
