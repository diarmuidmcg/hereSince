//
//  AccountSettings.swift
//  iosApp
//
//  Created by didi on 1/24/23.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI

struct AccountSettings: View {
    @ObservedObject var vm : IOSCounterViewModel
    var body: some View {
        VStack {
            HStack{
                Text("Account")
                    .foregroundColor(Color("TextColor"))
                    .padding(20)
                    .padding(.top, 20)
                //                        .padding(.bottom, 20)
                Spacer()
            }
            Button {
            // sign in button
                vm.signOut()
            } label: {
                Text("Sign Out")
                    .foregroundColor(Color.white)
                    .paragraphTwo()
                    .frame(width: UIScreen.screenWidth * 0.8, height: 40, alignment: .center)
            }
            .buttonStyle(BasicButton(bgColor: .secondary, secondaryColor: .primary))
            .padding(.vertical)
            Spacer()
        }
        
    }
}
