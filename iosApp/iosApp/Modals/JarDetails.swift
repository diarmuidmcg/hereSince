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
//                    if isEditing {
//                        TextField(vm.currJar.jar.jarContentName, text: $vm.currJar.jarContentName)
//                    }
//                    else {
                    Text(vm.currJar.jar.jarContentName)
                        
//                    }
                }
                Section(header: Text("Here Since")) {
//                    if isEditing {
//                        TextField(vm.currJar.jar.hereSince, text: $vm.currJar.jar.hereSince)
//                    }
//                    else {
                        Text(vm.currJar.jar.hereSince)
//                    }
                }
                Section(header: Text("Owned By")) {
//                    if isEditing {
//                        TextField(vm.currJar.jar.jarOwnerName, text: $vm.currJar.jar.jarOwnerName)
//                    }
//                    else {
                        Text(vm.currJar.jar.jarOwnerName)
//                    }
                }
                ForEach(vm.currentAddInfo.sorted(by: <), id: \.self) { element in
                    Section(header: Text("\(element.name)"))
                        {
                            Text("\(element.content)")
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
