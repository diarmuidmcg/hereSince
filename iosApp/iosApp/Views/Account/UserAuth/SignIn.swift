//
//  SignIn.swift
//  iosApp
//
//  Created by didi on 1/13/23.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI
import shared


struct SignIn: View {
    @ObservedObject var vm : IOSJarViewModel
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
                    if (vm.user.error.message != nil) {
                        Text((vm.user.showErrorText()))
                            .foregroundColor(.red)
                    }
                    // email
                    TextField("", text: $email)
                        .placeholder(when: email.isEmpty, placeholder: {
                            Text("Email")
                                .foregroundColor(.gray)
                                .buttonText()
                        })
                        .keyboardType(.emailAddress)
                        .foregroundColor(.darkButton)
                        .buttonText()
                        .padding(10)
                        .background(
                            ZStack {
                                RoundedRectangle(cornerRadius: .cornerRadiusTasks)
                                    .fill(Color.white)
                                    .shadow()
                                // is red if not entered or not valid email
                                if ((email == "" || !email.isValidEmail) && password != "") {
                                    RoundedRectangle(cornerRadius: .cornerRadiusTasks)
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
                            Text("Password")
                                .foregroundColor(.gray)
                                .buttonText()
                        })
                        .foregroundColor(.darkButton)
                        .buttonText()
                        .padding(10)
                        .background(
                            ZStack {
                                RoundedRectangle(cornerRadius: .cornerRadiusTasks)
                                    .fill(Color.white)
                                    .shadow()
                            }
                        )
                        .multilineTextAlignment(.leading)
                        .padding(.vertical, 5)
                    if errorOnPage {
                        Text("\(errorMessage)")
                            .foregroundColor(.red)
                            .paragraphTwo()
                            .padding(.vertical, 5)
                    }
                }
                Button {
                    // link to forgot password
                    
                } label: {
                    Text("Forgot Password?")
                        .foregroundColor(Color.white)
                        .buttonText()
                        .padding(.vertical, 10)
                }
                Button {
                // sign in button
                    vm.signUserInEmail(email: email, password: password)
                } label: {
                    Text("Sign In")
                        .foregroundColor(Color.white)
                        .paragraphTwo()
                        .frame(width: UIScreen.screenWidth * 0.8, height: 40, alignment: .center)
                }
                .buttonStyle(BasicButton(bgColor: .secondary, secondaryColor: .primary))
                .disabled(determineIfSignInButtonDisable())
                .addOpacity(determineIfSignInButtonDisable())
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
    
    @ViewBuilder func shadow() -> some View {
        self.shadow(radius: 3, x: 3, y: 3)
    }
    
    @ViewBuilder func addOpacity(_ needOpacity: Bool) -> some View {
        if needOpacity {
            self.opacity(0.5)
        } else {
            self
        }
    }
    
    @ViewBuilder func darkenView(_ darken: Bool) -> some View {
        if darken {
            self.brightness(-0.3)
        } else {
            self
        }
    }
    
}
