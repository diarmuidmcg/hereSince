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
//                        TextField(vm.currentJarOverview.jar.jarContentName, text: $vm.currentJar.jarContentName)
//                    }
//                    else {
                        Text(vm.currentJar.jarContentName)
                        
//                    }
                }
                Section(header: Text("Here Since")) {
//                    if isEditing {
//                        TextField(vm.currentJarOverview.jar.hereSince, text: $vm.currentJarOverview.jar.hereSince)
//                    }
//                    else {
                        Text(vm.currentJarOverview.jar.hereSince)
//                    }
                }
                Section(header: Text("Owned By")) {
//                    if isEditing {
//                        TextField(vm.currentJarOverview.jar.jarOwnerName, text: $vm.currentJarOverview.jar.jarOwnerName)
//                    }
//                    else {
                        Text(vm.currentJarOverview.jar.jarOwnerName)
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
