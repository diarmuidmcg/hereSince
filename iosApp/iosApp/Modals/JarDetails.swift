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
    @ObservedObject var vm : IOSCounterViewModel
    @Environment(\.colorScheme) var colorScheme
   
    @State var isEditing = false;
    
    
    var body: some View {
        VStack {
            HStack{
                Text("Jar")
                    .foregroundColor(colorScheme == .light ? Color.gray: Color.white)
                    .padding(20)
                    .padding(.top, 20)
//                        .padding(.bottom, 20)
               
                Spacer()
//                if owned by current user
//                if jarInformation.jarOwnerUserId == "123124213" {
                    Button("Edit Me"){isEditing.toggle()}
                        .buttonStyle(.borderless)
                        .padding()
//                }
            }
           
           
            
            List {
                Section(header: Text("Name")) {
                    if isEditing {
                        TextField(vm.currentJar.jarContentName, text: $vm.currentJar.jarContentName)
                    }
                    else {Text(vm.currentJar.jarContentName)}
                }
                Section(header: Text("Here Since")) {
                    if isEditing {
                        TextField(vm.currentJar.hereSince, text: $vm.currentJar.hereSince)
                    }
                    else {Text(vm.currentJar.hereSince)}
                }
                Section(header: Text("Owned By")) {
                    if isEditing {
                        TextField(vm.currentJar.jarOwnerName, text: $vm.currentJar.jarOwnerName)
                    }
                    else {Text(vm.currentJar.jarOwnerName)}
                }
                
                ForEach(vm.currentAddInfo.sorted(by: <), id: \.self) { element in
                    Section(header: Text("\(element.name)"))
                        {
                            Text("\(element.content)")
                            
                        }
                    }
                
                
//                ForEach(0...vm.currentJar.additionalInfo.count, id: \.self) { key in
////                    Section(header: Text("\(vm.currentJar.additionalInfo.mutableArrayValue(forKey: "name"))")) {
////                    Text("\(vm.currentJar.additionalInfo.mutableArrayValue(forKey: "content"))")
////                    }
//                    Section(header: Text("\(vm.currentJar.additionalInfo.mutableArrayValue(forKey: "name"))")) {
//                    Text("\(vm.currentJar.additionalInfo.mutableArrayValue(forKey: "content"))")
//                    }
//                }
                
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
