//
//  TapJarButton.swift
//  iosApp
//
//  Created by didi on 12/23/22.
//  Copyright © 2022 orgName. All rights reserved.
//

import SwiftUI

struct TapJarButton: View {
    @Binding var pressedButtonToLaunchNfc : Bool
    @Binding var launchModal : Bool
    
    @Environment(\.colorScheme) var colorScheme
    let sideGraphicHeight = UIScreen.screenHeight * 0.08
    
    
    var body: some View {
        
        Button(action: {
            withAnimation {
                pressedButtonToLaunchNfc = true
//                this will be determined by nfc resp
                launchModal = true;
            }
        }, label: {
            Image(systemName: "wave.3.forward.circle").resizable()
                .frame(width: sideGraphicHeight, height: sideGraphicHeight, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .frame(width: 250, height: 250)
                .foregroundColor(Color.green)

        })
        .buttonStyle(BasicButtonCircle(bgColor: colorScheme == .light ? Color.white: Color.gray, secondaryColor: .green))
        Text("Tap a Tag")
            .foregroundColor(colorScheme == .light ? Color.gray: Color.white)
    }
    
}
