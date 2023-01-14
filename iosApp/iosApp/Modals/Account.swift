//
//  Settings.swift
//  iosApp
//
//  Created by didi on 12/27/22.
//  Copyright © 2022 orgName. All rights reserved.
//

import SwiftUI

struct Account: View {
    
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
                    SignUp(email: $email, password: $password)
                        .padding(.horizontal)
                }
                else {
                    SignIn(email: $email, password: $password)
                        .padding(.horizontal)
                }
            }
//            .padding()
            Spacer()
        }.ignoresSafeArea()
        
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
