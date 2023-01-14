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
    @ObservedObject var vm : IOSCounterViewModel
    @Environment(\.colorScheme) var colorScheme
    @State var launchAccount = false
    
    var body: some View {
        VStack {
            HStack{
                Text("JarRing")
                    .foregroundColor(Color("TextColor"))
                    .padding(20)
                    .padding(.top, 20)
//                        .padding(.bottom, 20)
                Spacer()
                Button(action: {
                    launchAccount = true
                }, label: {
                    ZStack{
    //                    if no account
                        Image(systemName: "person.crop.circle.fill.badge.plus")
                            .font(.system(size: 30))
    //                    else has account
    //                    Image(systemName: "person.crop.circle.fill")
//                            .font(.system(size: 30))
                    }
                    .padding(20)
                    .padding(.top, 20)

                })
            }
            Spacer()
            TapJarButton(vm: vm)
            Spacer()
        }
        .sheet(isPresented: $vm.launchModal, content: { JarModal(vm: vm)})
        .sheet(isPresented: $launchAccount, content: {Account()})
    }
}
