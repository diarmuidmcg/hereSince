//
//  JarDetails.swift
//  iosApp
//
//  Created by didi on 12/27/22.
//  Copyright © 2022 orgName. All rights reserved.
//

import SwiftUI
import shared

struct JarDetails: View {
    let sampleJarInfo = JarAPI().sampleJarInfo
    @Environment(\.colorScheme) var colorScheme
    
    // for the results of the search bar
    let layout = [
            GridItem(.flexible())
        ]
   
    
    var body: some View {
        VStack {
            HStack{
                Text("Jar Details")
                    .foregroundColor(colorScheme == .light ? Color.gray: Color.white)
                    .padding(20)
                    .padding(.top, 20)
//                        .padding(.bottom, 20)
                Spacer()
//                if owned by current user
                if sampleJarInfo.jarOwnerUserId == "123124213" {
                    Button("Edit Me"){}
                        .buttonStyle(.borderless)
                        .padding()
                }
            }
           
           
            
            List {
                Section(header: Text("Name")) {
                    Text(sampleJarInfo.jarContentName)
                }
                Section(header: Text("Here Since")) {
                    Text(sampleJarInfo.hereSince)
                }
                Section(header: Text("Owned By")) {
                    Text(sampleJarInfo.jarOwnerName)
                }
                ForEach(sampleJarInfo.otherInfo.sorted(by: >), id: \.key) { key, value in
                    Section(header: Text(key)) {
                        Text(value)
                    }
                }
            }
            Spacer()
        }
        .ignoresSafeArea()
    }
}
