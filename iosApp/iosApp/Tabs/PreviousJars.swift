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
    let lotsOfSampleJars = JarAPI().lotsOfSampleJars
    @ObservedObject var vm : IOSCounterViewModel
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        VStack{
            HStack{
                Text("Previous Jars")
                    .foregroundColor(colorScheme == .light ? Color.gray: Color.white)
                    .padding(20)
                    .padding(.top, 20)
                Spacer()
                   
            }
            List {
//                if ()
                ForEach(lotsOfSampleJars, id: \.self) { value in
                    SingleJarMinimized(singleJar: value,vm:vm, isPrevious: true)
                }
            }
        }
    }
}
