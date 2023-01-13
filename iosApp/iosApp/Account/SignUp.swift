//
//  SignUp.swift
//  iosApp
//
//  Created by didi on 1/13/23.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI

struct SignUp: View {

    // so you can dismiss modal
//    @Binding var showModal : Bool
   
    @State var acceptedPrivacy = false
    @State var acceptedEmail = false
    
    @State var displayName: String = ""
    @Binding var email: String
    @Binding var password: String
    @State var confirmPassword: String = ""
    
    @State var errorOnPage: Bool = false
    @State var errorMessage : String = ""
    
    @Environment(\.colorScheme) var colorScheme
    
    func determineIfSignUpButtonDisable() -> Bool {
        if (acceptedPrivacy &&
            displayName != "" &&
                email.isValidEmail &&
            password != "" &&
            password == confirmPassword) {
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
                    // username
                    TextField("", text: $displayName)
                        .placeholder(when: displayName.isEmpty, placeholder: {
                            Text("name")
                                .foregroundColor(.gray)
                        })
//                        .foregroundColor(colorScheme == .light ? Color.darkButton: Color.white)
                        .foregroundColor(.black)
                        .padding(10)
                        .background(
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
//                                    .fill(colorScheme == .light ? Color.white : Color.darkButton )
                                    .fill(Color.white)
                                // is red if not entered
                                if (displayName == "" && acceptedPrivacy) {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.red)
                                        .opacity(0.40)
                                }
                            }
                       
                        )
                        .multilineTextAlignment(.leading)
                        .padding(.vertical, 5)
                    // email
                    TextField("", text: $email)
                        .placeholder(when: email.isEmpty, placeholder: {
                            Text("email")
                                .foregroundColor(.gray)
                        })
                        .keyboardType(.emailAddress)
//                        .foregroundColor(colorScheme == .light ? Color.darkButton: Color.white)
                        .foregroundColor(.blue)
                        .padding(10)
                        .background(
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white)
                                // is red if not entered or not valid email
                                if ((email == "" || !email.isValidEmail) && acceptedPrivacy) {
                                    RoundedRectangle(cornerRadius: 20)
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
                        .foregroundColor(.blue)
                        .padding(10)
                        .background(
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white)
                                // is red if not entered or not equal to confirm
                                if ((password == "" || password != confirmPassword) && acceptedPrivacy) {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.red)
                                        .opacity(0.40)
                                }
                            }
                        )
                        .multilineTextAlignment(.leading)
                        .padding(.vertical, 5)
                    // confirm password
                    SecureField("", text: $confirmPassword)
                        .placeholder(when: confirmPassword.isEmpty, placeholder: {
                            Text("confirm password")
                                .foregroundColor(.gray)
                        })
                        .foregroundColor(.blue)
                        .padding(10)
                        .background(
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white)
                                // is red if not entered or not equal to confirm
                                if ((confirmPassword == "" || password != confirmPassword) && acceptedPrivacy) {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.red)
                                        .opacity(0.40)
                                }
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
                .animation(.spring())
                VStack {
//                    ConsentedToEmail(acceptedEmail: $acceptedEmail)
//                        .padding(5)
//                    ConsentedToPrivacy(acceptedPrivacy: $acceptedPrivacy)
//                        .padding(5)
                }
                .animation(.spring())
                // sign up button
                Button {
                    
                } label: {
                    Text("sign up")
                        .foregroundColor(Color.white)
                        .frame(width: UIScreen.screenWidth * 0.8, height: 40, alignment: .center)
    //                    .padding(40)
                }
//                .buttonStyle(BasicFonzButton(bgColor: .amber, secondaryColor: colorScheme == .light ? Color.white: Color.darkButton))
                .disabled(determineIfSignUpButtonDisable())
//                .addOpacity(determineIfSignUpButtonDisable())
                .padding(.top)
                
            }
        }
    }
}
