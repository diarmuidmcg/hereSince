//
//  SingleJarMinimized.swift
//  iosApp
//
//  Created by didi on 12/27/22.
//  Copyright © 2022 orgName. All rights reserved.
//

import SwiftUI
import shared

struct SingleJarMinimized: View {
    var singleJar : JarInfo
    @ObservedObject var vm : IOSCounterViewModel
//    if the jar is owned by others, you wanna see the owner name on prev jar tab
    var isPrevious : Bool?
    @State var launchModal = false
    
    var body: some View {
        Button(action: {
            withAnimation {
                launchModal = true;
            }
        }, label: {
            VStack {
                Text(vm.currentJar.jarContentName).font(.system(size: 26.0))
                    .foregroundColor(.gray)
                    .padding(5)
                HStack {
                    Text("Here Since: \(vm.currentJar.hereSince)")
                        .foregroundColor(.gray)
                        .padding(.leading, 5)
                    Spacer()
                }
                if isPrevious ?? false {
                    HStack {
                        Text("Owned By: \(vm.currentJar.jarOwnerName)")
                            .foregroundColor(.gray)
                            .padding(.leading, 5)
                        Spacer()
                    }
                }
            }
        })
        .sheet(isPresented: $launchModal) {
            JarDetails(jarInformation: singleJar, vm: vm)
        }
        
        
    }
}

