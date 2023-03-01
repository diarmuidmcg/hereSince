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
    @State var newDate = Date()
    @State var jarChanges : Jar
    @State var jarExtras = Array<JarExtraInfo>()
    //    init function bc you need to create copies of both current jar & current jar extras
//    this is bc the data types in kotlin are diff than swift & can not map a foreach
    init(vm:IOSJarViewModel, jar: Jar) {
        self.vm = vm
        self.jar = jar
        
        _jarChanges = State(initialValue: Jar(copyJar: jar))
        _jarExtras = State(initialValue: setJarExtras(setJar: jar))
    }
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
            JarExtraAddButton(vm: vm, jarExtras: $jarExtras, isEditing: isEditing)
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
                        .onAppear {
    //                        so default is today
                            if (jarChanges.hereSince == ""){
                                jarChanges.hereSince = DateFormatter.formate.string(from: newDate)
                            }
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
                JarExtraItemsList(vm: vm, jarExtras: $jarExtras, isEditing: isEditing)
            }
            .foregroundColor(isEditing ? Color.gray : colorScheme == .light ? Color.black: Color.white)
            Spacer()
            if isEditing {
                
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

