//
//  UserAuth.swift
//  iosApp
//
//  Created by didi on 1/24/23.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI

struct UserAuth: View {
    
    @ObservedObject var vm : IOSJarViewModel
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
                        .addUnderline(active: onSignUp, color: Color("TextColor"))
                        .foregroundColor(Color("TextColor"))
                        .padding(.horizontal)
                    
                }
                Button {
                    withAnimation {
                        onSignUp = false
                    }
                    
                } label: {
                    Text("Sign in")
                        .addUnderline(active: !onSignUp, color: Color("TextColor"))
                        .foregroundColor(Color("TextColor"))
                        .padding(.horizontal)
                }
                Spacer()
               
                
            }
            .padding()

            ZStack{
                Color.primary
                                .ignoresSafeArea()
                VStack{
                    
                    if (onSignUp) {
                        SignUp(vm: vm,email: $email, password: $password)
                            .padding(.horizontal)
                    }
                    else {
                        SignIn(vm: vm,email: $email, password: $password)
                            .padding(.horizontal)
                    }
                    Spacer()
                }
                .padding(.top)
            }
//            .padding()
            Spacer()
        }.ignoresSafeArea()
    }
}


