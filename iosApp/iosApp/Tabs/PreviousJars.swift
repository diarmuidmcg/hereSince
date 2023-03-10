//
//  PreviousJars.swift
//  iosApp
//
//  Created by didi on 12/23/22.
//  Copyright © 2022 orgName. All rights reserved.
//

import SwiftUI
import shared

struct PreviousJars: View {
    @ObservedObject var vm : IOSJarViewModel
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        VStack{
            HStack{
                Text("Previous Jars")
                    .foregroundColor(Color("TextColor"))
                    .padding(20)
                    .padding(.top, 20)
                Spacer()
                   
            }
            List {
                if (vm.prevJars.count > 0) {
                    ForEach(vm.prevJars, id: \.self) { value in
                        SingleJarMinimized(singleJar: value,vm:vm, isPrevious: true)
                    }
                }
                else {
                    Text("You have not inspected any jars yet")
                }
                
            }
        }
    }
}
