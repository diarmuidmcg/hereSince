//
//  JarNoDetails.swift
//  iosApp
//
//  Created by didi on 12/27/22.
//  Copyright © 2022 orgName. All rights reserved.
//

import SwiftUI
import shared

struct JarNoDetails: View {
    @ObservedObject var vm : IOSJarViewModel
    @State var newJar = Jar()
    
    @Environment(\.colorScheme) var colorScheme

    @State var newDate = Date()
    @State var jarExtras = Array<JarExtraInfo>()
    
    var body: some View {
        VStack {
            HStack{
                Text("Configure This Jar")
                    .foregroundColor(Color("TextColor"))
                    .padding(20)
                    .padding(.top, 20)
                Spacer()
            }
//            jar Extra Add button
            JarExtraAddButton(vm: vm, jarExtras: $jarExtras, isEditing: true)
            List {
                Section(header: Text("Name")) {
                    TextField("Columbian Coffee", text: $newJar.jarContentName)
                }
                Section(header: Text("Here Since")) {
                    DatePicker(selection: $newDate, in: ...Date(), displayedComponents: .date) {
                        Text("Select a date")
                    }
                    .onAppear {
//                        so default is today
                        newJar.hereSince = DateFormatter.formate.string(from: newDate)
                    }
                    .onChange(of: newDate) { (date) in
                        newJar.hereSince = DateFormatter.formate.string(from: date)
                    }
                }
                Section(header: Text("Owned By")) {
                    TextField("Yeva", text: $newJar.jarOwnerName)
                }
//                jar extra details
                JarExtraItemsList(vm: vm, jarExtras: $jarExtras, isEditing: true)
            }
                .foregroundColor(Color.gray)
            Spacer()
            Button{
                withAnimation {
                   
                    vm.updateJarById(jarId: vm.currJar.jar._id, newJar: newJar, xtraInfo: jarExtras)
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
        
    }
}

