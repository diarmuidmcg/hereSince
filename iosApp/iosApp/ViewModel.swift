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

class IOSJarViewModel: ObservableViewModel, ObservableObject {
    @Published var loadingJar: Bool = false
    @Published var launchModal: Bool = false
    @Published var launchAccount: Bool = false
    @Published var enabled: Bool = true
    @Published var hasAccount: Bool = false
    @Published var currJar: JarOverview = JarOverview(type: JARTYPE.notregistered, jar: Jar())
//    store additional info in this bc SwiftUI ForEach can iterate a set, not a
//    MutableKotlinSet because that does not implement Hashable
//    @Published var currentAddInfo: Set<JarAdditionalInfo> = Set<JarAdditionalInfo>()
    @Published var prevJars: Array<Jar> = Array<Jar>()
    @Published var userJars: Array<Jar> = Array<Jar>()
    

    private let vm: SharedJarViewModel = SharedJarViewModel()
    
        
    override init() {
        super.init()
        start()
//        find out if user has account on init
//        self.fin()
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
    func updateJarById(jarId: String,newJar:Jar, xtraInfo: Array<JarAdditionalInfo>){
        self.loadingJar = true
        print("updating jar")
        
        vm.updateJarById(jarId: jarId.uppercased(),newJar:newJar, xtraInfo: xtraInfo)
    }
    
    func signUserUpEmail(email: String, password: String){
        self.launchAccount = false
        vm.signUserUpEmail(email: email, password: password)
    }
    
    func signUserInEmail(email: String, password: String){
        self.launchAccount = false
        vm.signUserInEmail(email: email, password: password)
    }
    
    func signOut(){
        self.launchAccount = false
        vm.signOut()
    }
    
    func userHasCreatedAcc(){
        vm.userHasCreatedAcc()
    }
    
       
    
    func start() {
        addObserver(observer: vm.observeJarOverview().watch { jarOverviewValue in
            self.currJar = jarOverviewValue! as JarOverview
            if (self.currJar.type == JARTYPE.jarhasdata) {
                self.currJar.jar.moreInfo = self.currJar.jar.additionalInfo as! Set<JarAdditionalInfo>
                self.currJar.jar.xtraInfo = self.currJar.jar.extraInfo as! Array<JarAdditionalInfo>
//                self.currentAddInfo = self.currJar.jar.additionalInfo as! Set<JarAdditionalInfo>
                print("curr jar O is " + self.currJar.jar._id)
            }
            self.loadingJar = false
        })
        addObserver(observer: vm.observePrevJars().watch { prevJarsList in
            print("updating prev jars")
            self.prevJars = prevJarsList as! Array<Jar>
        })
        addObserver(observer: vm.observeUserJars().watch { jarList in
            self.userJars = jarList as! Array<Jar>
        })
        addObserver(observer: vm.observeHasAccount().watch { account in
            if (account!.boolValue) {
                self.hasAccount = true
            } else {
                self.hasAccount = false
            }
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

// extension so JarAdditionalInfo can be iterated thru a SwiftUI Foreach
extension JarAdditionalInfo:Comparable, Identifiable {
    public static func < (lhs: JarAdditionalInfo, rhs: JarAdditionalInfo) -> Bool {
//       so ingredients always first
        if (rhs.name.uppercased() == "INGREDIENTS") {return false}
        else {return true}
    }
}

// extension to jar so that the above Additional Info can be iterated thru the SwiftUI Foreach -> otherwise the MutableSet is seen as NSElement
extension Jar {
    struct Holder {
            static var _moreInfo:Set<JarAdditionalInfo> = Set<JarAdditionalInfo>()
        static var _xtraInfo:Array<JarAdditionalInfo> = Array<JarAdditionalInfo>()
        }
        var moreInfo:Set<JarAdditionalInfo> {
            get {
                return Holder._moreInfo
            }
            set(newValue) {
                Holder._moreInfo = newValue
            }
        }
    var xtraInfo:Array<JarAdditionalInfo> {
        get {
            return Holder._xtraInfo
        }
        set(newValue) {
            Holder._xtraInfo = newValue
        }
    }
}
