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
//    can eventually create this on backend
    let jarOptions = [
        JarAdditionalInfo(name: "Ingredients",content:"",type: DataTypes.string),
        JarAdditionalInfo(name: "Expiration Date",content:"",type: DataTypes.date),
        JarAdditionalInfo(name: "Caffeinated",content:"",type: DataTypes.bool_),
        JarAdditionalInfo(name: "Vegetarian",content:"",type: DataTypes.bool_)
    ]
//    options to be shown after removing existing ones
    var shownJarOptions = Array<JarAdditionalInfo>()
    
//    @State var jarChanges = Jar(copyJar: jar)
    @State var jarChanges : Jar
    
    //    init function bc ReadNfc takes the other struct param ViewModel as a param
    init(vm:IOSJarViewModel, jar: Jar) {
        self.vm = vm
        self.jar = jar
        _jarChanges = State(initialValue: Jar(copyJar: jar))
        
        populateShownOptions()
    }
    
    mutating func populateShownOptions() {
        
        for option in jarOptions {
            if !jarChanges.xtraInfo.contains(option) {
                self.shownJarOptions.append(option)

            }
        }
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
                //                ForEach(jar.moreInfo.sorted(by: <), id: \.self) { element in
                //                    Section(header: Text("\(element.name)"))
                //                    {
                //                        Text("\(element.content)")
                //                    }
                //                }
                
                
                    ForEach(jarChanges.xtraInfo.indices, id: \.self) { element in
                        Section(header: Text("\(jarChanges.xtraInfo[element].name)"))
                        {
                            if isEditing {
                                TextField(jarChanges.xtraInfo[element].content, text: $jarChanges.xtraInfo[element].content)
                            }
                            else {
                                Text("\(jarChanges.xtraInfo[element].content)")
                            }
                        }
                    }
               
//                    ForEach(jarChanges.extraInfo.compactMap { $0 as? JarAdditionalInfo }, id: \.name) { element in
//                        Section(header: Text("\(element.name)"))
//                        {
//
//                            Text("\(element.content)")
//
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
                        ForEach(shownJarOptions, id: \.name) { element in
                            Button {
                                jarChanges.xtraInfo.append(JarAdditionalInfo(name: element.name, content: "", type: element.type))
//                                jarChanges.extraInfo.add(JarAdditionalInfo(name: element.name, content: "", type: element.type))
                            } label: {Text(element.name)}

                        }
                        Button("Cancel", role: .destructive) { showOptions = false }
                    }
                    Spacer()
                } else {
                    // Fallback on earlier versions
                }
                Spacer()
                Button{
                    withAnimation {
                        isEditing = false
                        
                        vm.updateJarById(jarId: jar._id, newJar: jarChanges, xtraInfo: jarChanges.xtraInfo)
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
