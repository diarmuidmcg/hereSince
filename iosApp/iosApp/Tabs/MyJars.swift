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
    @ObservedObject var vm : IOSJarViewModel
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        VStack{
            HStack{
                Text("My Jars")
                    .foregroundColor(Color("TextColor"))
                    .padding(20)
                    .padding(.top, 20)
                Spacer()
                    
            }
            List {
                if (vm.userJars.count > 0) {
                    ForEach(vm.userJars, id: \.self) { value in
                        SingleJarMinimized(singleJar: value,vm:vm)
                    }
                }
                else {
                    Text("You don't own any jars yet")
                }
            }
        }
        
    }
}
