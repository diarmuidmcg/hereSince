//
//  UserAuth.swift
//  iosApp
//
//  Created by didi on 1/24/23.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI

struct UserAuth: View {
    
    @ObservedObject var vm : IOSCounterViewModel
    @State var email: String = ""
    @State var password: String = ""
    
    @State var onSignUp : Bool = true
    var body: some View {
        VStack{
            Spacer()
            HStack{
                Spacer()
                Button {
                    withAnimation {
                        onSignUp = true
                    }
                } label: {
                    Text("Sign up")
                        .addUnderline(active: onSignUp, color: .primary)
                        .foregroundColor(Color.primary)
                        .padding(.horizontal)
                    
                }
                Button {
                    withAnimation {
                        onSignUp = false
                    }
                    
                } label: {
                    Text("Sign in")
                        .addUnderline(active: !onSignUp, color: .primary)
                        .foregroundColor(Color.primary)
                        .padding(.horizontal)
                }
                Spacer()
               
                
            }
            .padding()
            Spacer()
            ZStack{
                Color.primary
                                .ignoresSafeArea()
                if (onSignUp) {
                    SignUp(vm: vm,email: $email, password: $password)
                        .padding(.horizontal)
                }
                else {
                    SignIn(vm: vm,email: $email, password: $password)
                        .padding(.horizontal)
                }
            }
//            .padding()
            Spacer()
        }.ignoresSafeArea()
    }
}


