//
//  ViewJar.swift
//  iosApp
//
//  Created by didi on 12/23/22.
//  Copyright © 2022 orgName. All rights reserved.
//

import SwiftUI

struct ViewJar: View {
    @ObservedObject var vm : IOSJarViewModel
    
    var body: some View {
        HomePage(vm:vm)
    }
}

