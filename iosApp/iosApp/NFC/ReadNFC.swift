//
//  ReadNFC.swift
//  iosApp
//
//  Created by didi on 1/11/23.
//  Copyright © 2023 orgName. All rights reserved.
//

import Foundation
import CoreNFC
import SwiftUI

class ReadNFC: NSObject, ObservableObject, NFCTagReaderSessionDelegate {
    
    @ObservedObject var vm : IOSCounterViewModel
    var session: NFCTagReaderSession?
    
    init(vm: IOSCounterViewModel) {
        self.vm = vm
    }
    
    func launchNfcScan() {
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
        // ensures only one coaster present
        if tags.count > 1 {
            session.alertMessage = "More than one tag detected, please try again"
            session.invalidate()
        }
        // code after coaster scanned
        session.connect(to: tags.first!) { (error: Error?) in
            if nil != error{
                session.invalidate(errorMessage: "Connection failed")
            }
            if case let NFCTag.miFare(sTag) = tags.first! {
                
                // gets the UID from the coaster
                let uidFromTag = sTag.identifier.map{
                    String(format: "%.2hhx", $0) }.joined()
                print("UID:" + uidFromTag)
                
                // note on NFC popup returned to user
                session.alertMessage = "Properly connected!"
                // ends nfc session
                session.invalidate()
                DispatchQueue.main.async {
                    self.vm.findJarById(jarId: uidFromTag.uppercased())
                }
            }
        }
    }
}

