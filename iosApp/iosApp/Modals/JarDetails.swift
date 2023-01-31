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
    @ObservedObject var vm : IOSJarViewModel
    var jar : Jar
    @Environment(\.colorScheme) var colorScheme
   
    @State var isEditing = false;
    @State var showOptions = false;
//    can eventually create this on backend
    var jarOptions = ["Ingredients", "Expiration Date", "Caffeinated?", "Vegetarian?"]
        @State private var selectedJarOption = "Ingredients"
    @State var addingJarInfo = Array<JarAdditionalInfo>()
    @State var jarAddInfo : Set<JarAdditionalInfo>
    
//    @State var jarChanges = Jar(copyJar: jar)
    @State var jarChanges : Jar
    
    //    init function bc ReadNfc takes the other struct param ViewModel as a param
    init(vm:IOSJarViewModel, jar: Jar) {
        self.vm = vm
        self.jar = jar
        _jarChanges = State(initialValue: Jar(copyJar: jar))
        _jarAddInfo = State(initialValue: jar.moreInfo)
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
                
                if isEditing {

                    ForEach(addingJarInfo.indices, id: \.self) { element in
                        Section(header: Text("\(addingJarInfo[element].name)"))
                        {
                            TextField(addingJarInfo[element].content, text: $addingJarInfo[element].content)
                        }
                    }
                }
//                if isEditing {
//
//                    ForEach(jarAddInfo.sorted(by: <), id: \.self) { element in
//                        Section(header: Text("\(addingJarInfo[element].name)"))
//                        {
//                            TextField(addingJarInfo[element].content, text: $addingJarInfo[element].content)
//                        }
//                    }
//                }
        
                    
                
            }
            .foregroundColor(isEditing ? Color.gray : colorScheme == .light ? Color.black: Color.white)
            if isEditing {
                if #available(iOS 15.0, *) {
                    Button{
                        showOptions = true
                    } label: {
                        Image(systemName: "plus.app")
                            .font(.system(size: 30))
                    }
                    .foregroundColor(.primary)
                    .buttonStyle(.borderless)
                    .padding()
                    .confirmationDialog("Add More Info",
                                        isPresented: $showOptions) {
                        ForEach(jarOptions.sorted(by: <), id: \.self) { element in
                            Button {
                                addingJarInfo.append(JarAdditionalInfo(name: element, content: ""))
                            } label: {Text(element)}

                        }
                        Button("Cancel", role: .destructive) { showOptions = false }
                    }
                    Spacer()
                } else {
                    // Fallback on earlier versions
                }
                Spacer()
                Button{
                    isEditing = false
                    
//                    vm.updateJarById(jarId: jar._id, newJar: jarChanges)
                    for l in addingJarInfo{
                        print(l.content)
                    }
                    let setOfAddInfo = Set(addingJarInfo.map { $0 })
                    
                    jarChanges.additionalInfo = setOfAddInfo as! KotlinMutableSet<JarAdditionalInfo>
                    for l in jarChanges.additionalInfo{
                        print(l)
                    }
                } label:{
                    Text("Save")
                        .foregroundColor(Color.white)
                        .paragraphTwo()
                        .frame(width: UIScreen.screenWidth * 0.8, height: 40, alignment: .center)
                    
                }
                .foregroundColor(.primary)
                .buttonStyle(BasicButton(bgColor: .primary, secondaryColor: .white))
                .padding(.bottom)
            }
            Spacer()
                
        }
    }
}
