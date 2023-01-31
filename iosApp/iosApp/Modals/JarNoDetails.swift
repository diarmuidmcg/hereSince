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
    
    var body: some View {
        VStack {
            HStack{
                Text("Configure This Jar")
                    .foregroundColor(Color("TextColor"))
                    .padding(20)
                    .padding(.top, 20)
                Spacer()
            }
            Spacer()
            List {
                Section(header: Text("Name")) {
                    TextField("Columbian Coffee", text: $newJar.jarContentName)
                }
                Section(header: Text("Here Since")) {
                    TextField("12 July 2022", text: $newJar.hereSince)
                }
                Section(header: Text("Owned By")) {
                    TextField("Yeva", text: $newJar.jarOwnerName)
                }
                //                ForEach(jar.moreInfo.sorted(by: <), id: \.self) { element in
                //                    Section(header: Text("\(element.name)"))
                //                        {
                //                            Text("\(element.content)")
                //                        }
                //                    }
                //                }
                //                .foregroundColor(isEditing ? Color.gray : colorScheme == .light ? Color.black: Color.white)
            }
            Button("Save"){
                vm.updateJarById(jarId: vm.currJar.jar._id, newJar: newJar)
            }
                .foregroundColor(.primary)
                .buttonStyle(.borderless)
            
        }
        
    }
}

