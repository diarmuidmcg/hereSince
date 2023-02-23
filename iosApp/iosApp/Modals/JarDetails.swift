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
//    @State var showOptions = false;
    
    @State var newDate = Date()
//    @State var expirationDate = Date()
    //    @State var yesOrNo = false
    //    can eventually create this on backend
//    var jarOptions = [
//        JarExtraInfo(name: "Ingredients",content:"",type: "s"),
//        JarExtraInfo(name: "Expiration Date",content:"",type: "d"),
//        JarExtraInfo(name: "Caffeinated",content:"",type: "b"),
//        JarExtraInfo(name: "Vegetarian",content:"",type: "b")
//    ]
//
//
//    //    options to be shown after removing existing ones
//    var shownJarOptions = Array<JarExtraInfo>()
    
    @State var jarChanges : Jar
    @State var jarExtras = Array<JarExtraInfo>()
    //    init function bc ReadNfc takes the other struct param ViewModel as a param
    init(vm:IOSJarViewModel, jar: Jar) {
        self.vm = vm
        self.jar = jar
        
        _jarChanges = State(initialValue: Jar(copyJar: jar))
        _jarExtras = State(initialValue: setJarExtras(setJar: jar))
//        populateShownOptions()
        // still need to test
//        jarOptions = vm.fetchJarOptions()
    }
    
//    mutating func populateShownOptions() {
//        for option in jarOptions {
//            if !jarChanges.xtraInfo.contains(where: {$0.name == option.name}) {
//                self.shownJarOptions.append(option)
//            }
//        }
//    }
//    used to convert kotlin data type to swift data type of Jar Extra Infos
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
                Text(jarChanges.jarContentName)
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
//            jar Extra Add button
            JarExtraAddButton(vm: vm, jarChanges: $jarChanges, jarExtras: $jarExtras, isEditing: isEditing)
            List {
                
                if isEditing {
                    Section(header: Text("Name")) {
                        TextField(jarChanges.jarContentName, text: $jarChanges.jarContentName)
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
//                jar extra details
                JarExtraItemsList(vm: vm, jarChanges: $jarChanges, jarExtras: $jarExtras, isEditing: isEditing)
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

