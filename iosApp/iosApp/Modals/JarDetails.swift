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
    @State var jarInformation : JarInfo
    @ObservedObject var vm : IOSCounterViewModel
    @Environment(\.colorScheme) var colorScheme
   
    @State var isEditing = false;
    
    
    var body: some View {
        VStack {
            HStack{
                Text(vm.currentJar._id)
                    .foregroundColor(colorScheme == .light ? Color.gray: Color.white)
                    .padding(20)
                    .padding(.top, 20)
//                        .padding(.bottom, 20)
               
                Spacer()
//                if owned by current user
                if jarInformation.jarOwnerUserId == "123124213" {
                    Button("Edit Me"){isEditing.toggle()}
                        .buttonStyle(.borderless)
                        .padding()
                }
            }
           
           
            
            List {
                Section(header: Text("Name")) {
                    if isEditing {
                        TextField(jarInformation.jarContentName, text: $jarInformation.jarContentName)
                    }
                    else {Text(jarInformation.jarContentName)}
                }
                Section(header: Text("Here Since")) {
                    if isEditing {
                        TextField(jarInformation.hereSince, text: $jarInformation.hereSince)
                    }
                    else {Text(jarInformation.hereSince)}
                }
                Section(header: Text("Owned By")) {
                    if isEditing {
                        TextField(jarInformation.jarOwnerName, text: $jarInformation.jarOwnerName)
                    }
                    else {Text(jarInformation.jarOwnerName)}
                }
                ForEach(jarInformation.otherInfo.sorted(by: >), id: \.key) { key, value in
                    Section(header: Text(key)) {
//                        if isEditing {
//                            TextField(value, text: $key)
//                        }
//                        else {Text(value)}
                        Text(value)
                    }
                }
                
            }
            .foregroundColor(isEditing ? Color.gray : colorScheme == .light ? Color.black: Color.white)
            if isEditing {
                Button("Save"){isEditing = false}
                    .foregroundColor(.blue)
                    .buttonStyle(.borderless)
                    
            }
            Spacer()
                
        }
        
        
    }
}
