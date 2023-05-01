//
//  Settings.swift
//  iosApp
//
//  Created by didi on 12/27/22.
//  Copyright © 2022 orgName. All rights reserved.
//

import SwiftUI

struct Account: View {
    @ObservedObject var vm : IOSJarViewModel
    
    var body: some View {
        if (!vm.user.hasAccount) {
            UserAuth(vm:vm)
        }
//                    else has account
        else {
            AccountSettings(vm: vm)
        }
        
    }
       
}

extension Text {
    func addUnderline(active: Bool, color: Color) -> some View {
        if active {
            return self.underline(color: color)
        } else {
            return self
        }
    }
    
    
}
