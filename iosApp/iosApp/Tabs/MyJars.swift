//
//  MyJars.swift
//  iosApp
//
//  Created by didi on 12/23/22.
//  Copyright © 2022 orgName. All rights reserved.
//

import SwiftUI
import shared

struct MyJars: View {
    let lotsOfSampleJars = JarAPI().lotsOfSampleJars
    @ObservedObject var vm : IOSCounterViewModel
    @State var launchSettingsModal = false
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        VStack{
            HStack{
                Text("Jar Details")
                    .foregroundColor(colorScheme == .light ? Color.gray: Color.white)
                    .padding(20)
                    .padding(.top, 20)
                Spacer()
                    Button("Settings"){
                        launchSettingsModal = true
                    }
                        .buttonStyle(.borderless)
                        .padding()
            }
            List {
                
                ForEach(lotsOfSampleJars, id: \.self) { value in
                    SingleJarMinimized(singleJar: value, vm:vm)
                }
            }
        }
        .sheet(isPresented: $launchSettingsModal) {
            Settings()
        }
    }
}
