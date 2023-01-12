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
    @ObservedObject var vm : IOSCounterViewModel
    @ObservedObject var readNfc : ReadNFC
  
    init(vm:IOSCounterViewModel) {
        self.vm = vm
        self.readNfc = ReadNFC(vm: vm)
    }
    
    @Environment(\.colorScheme) var colorScheme
    let sideGraphicHeight = UIScreen.screenHeight * 0.08
    
    
    var body: some View {
        
        Button(action: {
            withAnimation {
 
//                this will be determined by nfc resp
//                vm.loadingJar = true
//                vm.launchModal = true
                readNfc.launchNfcScanWithoutButton()
//                vm.findJarById(jarId: "")
//                vm.findJarById(jarId: "04C6E41AE66C80")
//                vm.findJarById(jarId: "0414041AE66C85")
                
                
            }
        }, label: {
            Image(systemName: "wave.3.forward.circle").resizable()
                .frame(width: sideGraphicHeight, height: sideGraphicHeight, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .frame(width: 250, height: 250)
                .foregroundColor(Color.blue)

        })
        .buttonStyle(BasicButtonCircle(bgColor: colorScheme == .light ? Color.white: Color.gray, secondaryColor: .blue))
        Text("Tap a Jar")
            .foregroundColor(colorScheme == .light ? Color.gray: Color.white)
    }
    
}
