//
//  SignIn.swift
//  iosApp
//
//  Created by didi on 1/13/23.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI

struct SignIn: View {

    // so you can dismiss modal
//    @Binding var showModal : Bool
    
    @Binding var email: String
    @Binding var password: String
    
    @State var errorOnPage: Bool = false
    @State var errorMessage : String = ""
    
    @Environment(\.colorScheme) var colorScheme
    
    func determineIfSignInButtonDisable() -> Bool {
        if (email.isValidEmail &&
            password != "") {
            return false
        }
        else {
            return true
        }
    }
    
    var body: some View {
        ZStack{
            VStack{
                VStack{
                    // email
                    TextField("", text: $email)
                        .placeholder(when: email.isEmpty, placeholder: {
                            Text("email")
                                .foregroundColor(.gray)
                        })
                        .keyboardType(.emailAddress)
                        .foregroundColor(Color.gray)
                        .padding(10)
                        .background(
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
//                                    .fill(colorScheme == .light ? Color.white : Color.darkButton )
                                    .fill(Color.white)
                                // is red if not entered or not valid email
                                if ((email == "" || !email.isValidEmail) && password != "") {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.red)
                                        .opacity(0.40)
                                }
                            }
                        )
                        .multilineTextAlignment(.leading)
                        .padding(.vertical, 5)
                    // password
                    SecureField("", text: $password)
                        .placeholder(when: password.isEmpty, placeholder: {
                            Text("password")
                                .foregroundColor(.gray)
                        })
                        .foregroundColor(.black)
                        .padding(10)
                        .background(
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white)
                            }
                        )
                        .multilineTextAlignment(.leading)
                        .padding(.vertical, 5)
                    if errorOnPage {
                        Text("\(errorMessage)")
                            .foregroundColor(.red)
                            .padding(.vertical, 5)
                    }
                }
                Button {
                    // link to forgot password
                    
                } label: {
                    Text("forgot password?")
                        .foregroundColor(Color.white)
                        .padding(.vertical, 10)
                }
                // sign in button
                Button {
//                    self.showModal.toggle()
                   
                    
                } label: {
                    Text("sign in")
                        .foregroundColor(Color.white)
                        .frame(width: UIScreen.screenWidth * 0.8, height: 40, alignment: .center)
    //                    .padding(40)
                }
                
                .disabled(determineIfSignInButtonDisable())
//                .addOpacity(determineIfSignInButtonDisable())
                .padding(.vertical)
            }
        }
    }
}

public extension String {
    var isValidEmail: Bool {
        let name = "[A-Z0-9a-z]([A-Z0-9a-z._%+-]{0,30}[A-Z0-9a-z])?"
        let domain = "([A-Z0-9a-z]([A-Z0-9a-z-]{0,30}[A-Z0-9a-z])?\\.){1,5}"
        let emailRegEx = name + "@" + domain + "[A-Za-z]{2,8}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: self)
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
