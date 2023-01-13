//
//  JarModal.swift
//  iosApp
//
//  Created by didi on 1/11/23.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI
import shared

struct JarModal: View {
    @ObservedObject var vm : IOSCounterViewModel
    var body: some View {
        if (vm.loadingJar) {
            VStack {
                Text("Loading Jar Info")
                ProgressView()
                    .progressViewStyle(.circular)
            }
            
        }
        else {
            if (vm.currJar.type == JARTYPE.jarhasdata) {
                JarDetails(vm: vm, jar: vm.currJar.jar)
            }
            else if (vm.currJar.type == JARTYPE.jarnodata) {
                JarNoDetails()
            }
            else {
                NotRegistered()
            }
        }
    }
}
