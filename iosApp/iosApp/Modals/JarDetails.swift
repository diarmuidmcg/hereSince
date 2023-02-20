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
    
    @State var newDate = Date()
    @State var expirationDate = Date()
    //    @State var yesOrNo = false
    //    can eventually create this on backend
    let jarOptions = [
        JarExtraInfo(name: "Ingredients",content:"",type: "s"),
        JarExtraInfo(name: "Expiration Date",content:"",type: "d"),
        JarExtraInfo(name: "Caffeinated",content:"",type: "b"),
        JarExtraInfo(name: "Vegetarian",content:"",type: "b")
    ]
    //    options to be shown after removing existing ones
    var shownJarOptions = Array<JarExtraInfo>()
    
    @State var jarChanges : Jar
    @State var jarExtras = Array<JarExtraInfo>()
    //    init function bc ReadNfc takes the other struct param ViewModel as a param
    init(vm:IOSJarViewModel, jar: Jar) {
        self.vm = vm
        self.jar = jar
        
        _jarChanges = State(initialValue: Jar(copyJar: jar))
        _jarExtras = State(initialValue: setJarExtras(setJar: jar))
        populateShownOptions()
    }
    
    mutating func populateShownOptions() {
        for option in jarOptions {
            if !jarChanges.xtraInfo.contains(where: {$0.name == option.name}) {
                self.shownJarOptions.append(option)
            }
        }
    }
    
    func setJarExtras(setJar: Jar) -> Array<JarExtraInfo>{
        print("setting jar")
        var jarDetails = Array<JarExtraInfo>()
        for option in setJar.extraFields {
            jarDetails.append(JarExtraInfo(copyAddInfo: option as! JarExtraInfo))
        }
        return jarDetails
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
                if jar.jarOwnerUserId == vm.user.user?.id {
                    Button("Edit Me"){
                        withAnimation {
                            isEditing.toggle()
                        }
                    }
                    .buttonStyle(.borderless)
                    .padding()
                }
            }
            if (isEditing && shownJarOptions.count > 0) {
                if #available(iOS 15.0, *) {
                    Button{
                        showOptions = true
                    } label: {
                        HStack{
                            Spacer()
                            Image(systemName: "plus.app")
                                .font(.system(size: 30))
                            Spacer()
                        }
                    }
                    .foregroundColor(.primary)
                    .buttonStyle(.borderless)
                    .confirmationDialog("Add More Info",
                                        isPresented: $showOptions) {
                        ForEach(shownJarOptions, id: \.name) { element in
                            Button {
//                                prevents the user from adding 'ingredients' more than once etc
                                if !jarChanges.xtraInfo.contains(where: {$0.name == element.name}) {
                                    jarChanges.xtraInfo.append(JarExtraInfo(name: element.name, content: "", type: element.type))
                                    jarExtras.append(JarExtraInfo(name: element.name, content: "", type: element.type))
                                }
                            } label: {Text(element.name)}
                        }
                    }
                    Spacer()
                } else {
                    // Fallback on earlier versions
                }
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
                        DatePicker(selection: $newDate, in: ...Date(), displayedComponents: .date) {
                            Text("Select a date")
                        }
                        .onChange(of: newDate) { (date) in
                            jarChanges.hereSince = DateFormatter.formate.string(from: date)
                        }
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
                ForEach(jarExtras.indices, id: \.self) { element in
                    Section(header: Text("\(jarExtras[element].name)" ))
                    {
                        if isEditing {
                            if (jarExtras[element].type == "d") {
                                DatePicker(selection: $expirationDate, displayedComponents: .date) {
                                    Text("Select a date")
                                }
                                .onChange(of: expirationDate) { (date) in
                                    jarExtras[element].content = DateFormatter.formate.string(from: date)
                                }
                            }
                            else if (jarExtras[element].type == "b") {
                                Picker("Yes or No", selection: $jarExtras[element].content, content: {
                                    Text("Yes").tag("Yes")
                                    Text("No").tag("No")
                                })
                                .pickerStyle(SegmentedPickerStyle())
                            }
                            else {
                                TextField(jarExtras[element].content, text: $jarExtras[element].content)
                            }
//                            Button{
//                                jarExtras.remove(at: element)
//                                jarChanges.xtraInfo.remove(at: element)
//                            } label: {
//                                HStack{
//                                    Spacer()
//                                    Image(systemName: "minus.square")
//                                        .font(.system(size: 20))
//                                        .foregroundColor(Color(.red))
//                                    Spacer()
//                                }
//                            }
                        }
                        else {
                            Text("\(jarExtras[element].content)")
                        }
                    }
                }
            }
            .foregroundColor(isEditing ? Color.gray : colorScheme == .light ? Color.black: Color.white)
            if isEditing {
                Spacer()
                Button{
                    withAnimation {
                        isEditing = false
                        vm.updateJarById(jarId: jar._id, newJar: jarChanges, xtraInfo: jarExtras)
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

