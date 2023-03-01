//
//  JarExtraAddButton.swift
//  iosApp
//
//  Created by didi on 2/23/23.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI
import shared

struct JarExtraAddButton: View {
    @ObservedObject var vm : IOSJarViewModel
    @Binding var jarExtras : Array<JarExtraInfo>
    var isEditing : Bool
    
    @State var showOptions = false;
    var jarOptions : Array<JarExtraInfo>
    
    mutating func populateShownOptions(extraOptions: Array<JarExtraInfo>) {
        for option in extraOptions {
            if !jarExtras.contains(where: {$0.name == option.name}) {
                self.shownJarOptions.append(option)
            }
        }
    }
    
    init(vm:IOSJarViewModel, jarExtras:Binding<Array<JarExtraInfo>>, isEditing:Bool) {
        self.vm = vm
        _jarExtras = jarExtras
        self.isEditing = isEditing
// fetch jar options from kotlin
        jarOptions = vm.fetchJarOptions()
        populateShownOptions(extraOptions: jarOptions)
        
    }
    
    
    //    options to be shown after removing existing ones
    var shownJarOptions = Array<JarExtraInfo>()
    
    var body: some View {
        VStack{
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
                                if !jarExtras.contains(where: {$0.name == element.name}) {
                                    jarExtras.append(JarExtraInfo(name: element.name, content: "", type: element.type))
                                }
                            } label: {Text(element.name)}
                        }
                    }
                } else {
                    // Fallback on earlier versions
                }
            }
        }
    }
}

