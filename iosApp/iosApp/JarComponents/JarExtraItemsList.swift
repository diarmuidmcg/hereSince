//
//  JarExtraItemsList.swift
//  iosApp
//
//  Created by didi on 2/23/23.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI
import shared

struct JarExtraItemsList: View {
    @ObservedObject var vm : IOSJarViewModel
    @Binding var jarExtras : Array<JarExtraInfo>
    var isEditing : Bool
    
    @State var expirationDate = Date()
    
    var body: some View {
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
}


