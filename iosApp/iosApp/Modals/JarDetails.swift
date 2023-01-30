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
    var jar : Jar
    @Environment(\.colorScheme) var colorScheme
   
    @State var isEditing = false;
    
//    @State var jarChanges = Jar(copyJar: jar)
    @State var jarChanges : Jar
    
    //    init function bc ReadNfc takes the other struct param ViewModel as a param
    init(vm:IOSCounterViewModel, jar: Jar) {
        self.vm = vm
        self.jar = jar
        _jarChanges = State(initialValue: Jar(copyJar: jar))
    }
    
    var body: some View {
        VStack {
            HStack{
                Text("Jar")
                    .foregroundColor(Color("TextColor"))
                    .padding(20)
                    .padding(.top, 20)
                Spacer()
//                if owned by current user
//                if jarInformation.jarOwnerUserId == "123124213" {
                    Button("Edit Me"){
                        isEditing.toggle()
//                        jarChanges = jar
                    }
                        .buttonStyle(.borderless)
                        .padding()
//                }
            }
            List {
                Section(header: Text("Name")) {
                    if isEditing {
                        TextField(jarChanges.jarContentName, text: $jarChanges.jarContentName)
                    }
                    else {
                    Text(jar.jarContentName)
                        
                    }
                }
                Section(header: Text("Here Since")) {
                    if isEditing {
                        TextField(jar.hereSince, text: $jarChanges.hereSince)
                    }
                    else {
                        Text(jar.hereSince)
                    }
                }
                Section(header: Text("Owned By")) {
                    if isEditing {
                        TextField(jar.jarOwnerName, text: $jarChanges.jarOwnerName)
                            
                    }
                    else {
                        Text(jar.jarOwnerName)
                    }
                }
                ForEach(jar.moreInfo.sorted(by: <), id: \.self) { element in
                    Section(header: Text("\(element.name)"))
                        {
                            Text("\(element.content)")
                        }
                    }
                }
                .foregroundColor(isEditing ? Color.gray : colorScheme == .light ? Color.black: Color.white)
            if isEditing {
                Button("Save"){
                    isEditing = false
                    vm.updateJarById(jarId: jar._id, newJar: jarChanges)
                }
                    .foregroundColor(.primary)
                    .buttonStyle(.borderless)
            }
            Spacer()
                
        }
    }
}
