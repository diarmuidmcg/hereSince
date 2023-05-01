//
//  TapJarButton.swift
//  iosApp
//
//  Created by didi on 12/23/22.
//  Copyright © 2022 orgName. All rights reserved.
//

import SwiftUI
import shared

struct TapJarButton: View {
    @ObservedObject var vm : IOSJarViewModel
//    not taken from parent, created in init
    @ObservedObject var readNfc : ReadNFC
  
//    init function bc ReadNfc takes the other struct param ViewModel as a param
    init(vm:IOSJarViewModel) {
        self.vm = vm
        self.readNfc = ReadNFC(vm: vm)
    }
    
    @Environment(\.colorScheme) var colorScheme
    let sideGraphicHeight = UIScreen.screenHeight * 0.08
    
    
    var body: some View {
        
        Button(action: {
            withAnimation {
//                launch nfc to get
                readNfc.launchNfcScan()
            }
        }, label: {
            Image(systemName: "wave.3.forward")
                .font(.system(size: 60))
                .frame(width: 250, height: 250)
                .foregroundColor(Color.white)

        })
        .buttonStyle(BasicButtonCircle(bgColor: .primary, secondaryColor: .white))
        Text("Tap a Jar")
            .foregroundColor(Color("TextColor"))
            .subheading()
    }
    
}
