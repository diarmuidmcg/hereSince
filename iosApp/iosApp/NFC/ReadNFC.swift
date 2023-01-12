//
//  ReadNFC.swift
//  iosApp
//
//  Created by didi on 1/11/23.
//  Copyright © 2023 orgName. All rights reserved.
//

import Foundation

import SwiftUI
import CoreNFC
import UIKit

//extension UIButton {
//    open override func draw(_ rect: CGRect) {
//        //provide custom style
//        self.layer.cornerRadius = .cornerRadiusTasks
//        self.layer.masksToBounds = true
//    }
//
//}




class ReadNFC: NSObject, ObservableObject, NFCTagReaderSessionDelegate {
    
    @ObservedObject var vm : IOSCounterViewModel
    // to return jar uid
    @Published var jarUid:String = ""
    var session: NFCTagReaderSession?
    
    init(vm: IOSCounterViewModel) {
        self.vm = vm
        
    }
    
    
    // function that fires when button is pressed
    @IBAction func beginNfcScan(_ sender: Any) {
        print("begin nfc started")
        self.session = NFCTagReaderSession(pollingOption: .iso14443, delegate: self, queue: nil)
        // this createss nfc alert
        self.session?.alertMessage = "Tap the Fonz Coaster"
        // this begins the alert
        print("about to begin")
        self.session?.begin()
        print("isReady: \(String(describing: self.session?.isReady))")
        
    }
    // function that fires without button
    func launchNfcScanWithoutButton() {
        self.session = NFCTagReaderSession(pollingOption: .iso14443, delegate: self)
        // this createss nfc alert
        self.session?.alertMessage = "Tap the Fonz Coaster"
        // this begins the alert
        self.session?.begin()
    }
    
    func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
        print("session begun")
        
    }
    
    func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
        print(Error.self)
        session.invalidate()
    }
    
    // runs when function read is valid
    func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        print("got this far")
        // ensures only one coaster present
        if tags.count > 1 {
            print("morethan one ")
            session.alertMessage = "more than one tag detected, please try again"
            session.invalidate()
        }
        // code after coaster scanned
        session.connect(to: tags.first!) { (error: Error?) in
            if nil != error{
                print("connection failed")
                session.invalidate(errorMessage: "connection failed")
            }
            if case let NFCTag.miFare(sTag) = tags.first! {
                
                // gets the UID from the coaster
                let uidFromTag = sTag.identifier.map{
                    String(format: "%.2hhx", $0) }.joined()
                print("UID:" + uidFromTag)
                
                // note on NFC popup returned to user
                session.alertMessage = "properly connected!"
                // ends nfc session
                session.invalidate()
                
                DispatchQueue.main.async {
                    self.vm.findJarById(jarId: uidFromTag.uppercased())
                    // sets vars to return to user
//                    self.jarUid = uidFromTag
                }
            }
        }
    }
}

