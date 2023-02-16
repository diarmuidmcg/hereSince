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
    @Published var currJar: JarOverview = JarOverview(type: JARTYPE.notregistered, jar: Jar())
    @Published var prevJars: Array<Jar> = Array<Jar>()
    @Published var user: UserDetails = UserDetails()
    

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
    func updateJarById(jarId: String,newJar:Jar, xtraInfo: Array<JarAdditionalInfo>){
        self.loadingJar = true
        vm.updateJarById(jarId: jarId.uppercased(),newJar:newJar, xtraInfo: xtraInfo)
    }
    
    func signUserUpEmail(email: String, password: String){
        vm.signUserUpEmail(email: email, password: password)
    }
    
    func signUserInEmail(email: String, password: String){
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
                self.currJar.jar.xtraInfo = self.currJar.jar.extraInfo as! Array<JarAdditionalInfo>
            }
            self.loadingJar = false
        })
        addObserver(observer: vm.observePrevJars().watch { prevJarsList in
            print("updating prev jars")
            self.prevJars = prevJarsList as! Array<Jar>
        })
        addObserver(observer: vm.observeUserDetails().watch { userD in
            self.user = userD!
            self.user.jars = self.user.userJars as! Array<Jar>
//            leave account modal if signed in
            if ((userD?.hasAccount) == true) {
                self.launchAccount = false
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
        static var _xtraInfo:Array<JarAdditionalInfo> = Array<JarAdditionalInfo>()
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

// extension so Jar can be iterated thru a SwiftUI Foreach
extension Jar:Comparable, Identifiable {
    public static func < (lhs: Jar, rhs: Jar) -> Bool {
        return true
    }
}

// extension to UserDetails so that the above Additional Info can be iterated thru the SwiftUI Foreach -> otherwise the MutableSet is seen as NSElement
extension UserDetails {
    struct Holder {
        static var _jars:Array<Jar> = Array<Jar>()
        }
    var jars:Array<Jar> {
        get {
            return Holder._jars
        }
        set(newValue) {
            Holder._jars = newValue
        }
    }
}
