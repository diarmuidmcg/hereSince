//
//  HomePage.swift
//  iosApp
//
//  Created by didi on 12/23/22.
//  Copyright © 2022 orgName. All rights reserved.
//

import SwiftUI
import shared

struct HomePage: View {
    @State var pressedButtonToLaunchNfc = false;
    @State var launchModal = false;
    @Environment(\.colorScheme) var colorScheme
    
    let sampleJarInfo = JarAPI().sampleJarInfo
    
    var body: some View {
        VStack {
            HStack{
                Text("Here Since")
                    .foregroundColor(colorScheme == .light ? Color.gray: Color.white)
                    .padding(20)
                    .padding(.top, 20)
//                        .padding(.bottom, 20)
                Spacer()
            }
            Spacer()
            TapJarButton(pressedButtonToLaunchNfc: $pressedButtonToLaunchNfc, launchModal: $launchModal)
            Spacer()
        }
        .sheet(isPresented: $launchModal, content: { JarDetails(jarInformation: sampleJarInfo)})
    }
}
