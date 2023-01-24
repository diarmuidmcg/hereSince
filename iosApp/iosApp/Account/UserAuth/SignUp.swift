//
//  SignUp.swift
//  iosApp
//
//  Created by didi on 1/13/23.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI

struct SignUp: View {
    @ObservedObject var vm : IOSCounterViewModel
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
        if (displayName != "" &&
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
                            Text("Name")
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
                                // is red if not entered
                                if (displayName == "" && acceptedPrivacy) {
                                    RoundedRectangle(cornerRadius: .cornerRadiusTasks)
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
                                if ((email == "" || !email.isValidEmail) && acceptedPrivacy) {
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
                                // is red if not entered or not equal to confirm
                                if ((password == "" || password != confirmPassword) && acceptedPrivacy) {
                                    RoundedRectangle(cornerRadius: .cornerRadiusTasks)
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
                            Text("Confirm Password")
                                .foregroundColor(.gray)
                                .buttonText()
                        })
                        .foregroundColor(.darkButton)
                        .buttonText()
                        .padding(10)
                        .background(
                            ZStack {
                                RoundedRectangle(cornerRadius: .cornerRadiusTasks)
//                                    .fill(colorScheme == .light ? Color.white : Color.darkButton )
                                    .fill(Color.white)
                                    .shadow()
                                // is red if not entered or not equal to confirm
                                if ((confirmPassword == "" || password != confirmPassword) && acceptedPrivacy) {
                                    RoundedRectangle(cornerRadius: .cornerRadiusTasks)
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
                            .paragraphTwo()
                            .padding(.vertical, 5)
                    }
                }
                .animation(.spring())
                // terms
                VStack {
//                    ConsentedToEmail(acceptedEmail: $acceptedEmail)
//                        .padding(5)
//                    ConsentedToPrivacy(acceptedPrivacy: $acceptedPrivacy)
//                        .padding(5)
                }
                .animation(.spring())
                // sign up button
                
                Button {
                    vm.signUserUpEmail(email: email, password: password)
                } label: {
                    Text("Sign Up")
                        .foregroundColor(Color.white)
                        .paragraphTwo()
                        .frame(width: UIScreen.screenWidth * 0.8, height: 40, alignment: .center)
    //                    .padding(40)
                }
                .buttonStyle(BasicButton(bgColor: .secondary, secondaryColor: .primary))
                .disabled(determineIfSignUpButtonDisable())
                .addOpacity(determineIfSignUpButtonDisable())
                .padding(.top)
                
            }
        }
    }
}
