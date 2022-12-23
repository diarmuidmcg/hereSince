//
//  HomePage.swift
//  iosApp
//
//  Created by didi on 12/23/22.
//  Copyright © 2022 orgName. All rights reserved.
//

import SwiftUI

struct HomePage: View {
    @State var pressedButtonToLaunchNfc = false;
    @Environment(\.colorScheme) var colorScheme
    
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
            TapJarButton(pressedButtonToLaunchNfc: $pressedButtonToLaunchNfc)
            Spacer()
        }
    }
}
