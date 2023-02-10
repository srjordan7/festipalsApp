//
//  ContentView.swift
//  festipalsApp
//
//  Created by sierra jordan on 2/9/23.
//

import SwiftUI
import Firebase

struct LogInView: View {
    // log in/sign up picker
    @State var logInMode = false
    // email/pass field variables
    @State var email = ""
    @State var password = ""
        
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    // mode picker
                    Picker(selection: $logInMode, label: Text("Picker here")) {
                        Text("log in")
                            .tag(true)
                        Text("sign up")
                            .tag(false)
                    }.pickerStyle(SegmentedPickerStyle())
                    .padding()
                    
                    // profile picture entry
                    if !logInMode {
                        Button {
                            // ADD BUTTON FUNCTIONALITY
                        } label: {
                            Image(systemName: "person")
                                .font(.system(size: 34))
                                .padding()
                        }
                    }
                    
                    // email/pass entry
                    Group {
                        TextField("email", text: $email)
                            .keyboardType(.emailAddress)
                        SecureField("password", text: $password)
                    }
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .padding(12)
//                    .background(.white) // text field background color
                    
                    
                    // create account button
                    Button {
                        signInUp()
                        // ADD ALERT FOR ERRORS
                    } label: {
                        HStack {
                            Spacer()
                            Text(logInMode ? "log in" : "create account")
                                .foregroundColor(.white) // button text color
                                .padding(.vertical, 10)
                            Spacer()
                        }.background(Color.green) // button background color
                    }
                }
                .padding()
            }
            .navigationTitle(logInMode ? "log in" : "create account")
            .background(Color("BackgroundColor")
                .ignoresSafeArea()) // background color
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    // log in/sign up function
    private func signInUp() {
        if logInMode {
            logInAccount()
        } else {
            createNewAccount()
        }
    }
    
    @State var logInStatusMsg = ""
    
    // create new account function
    private func createNewAccount() {
        Auth.auth().createUser(withEmail: email, password: password) {
            result, error in
            if let error = error {
                print("failed to create user: \(error.localizedDescription)")
                self.logInStatusMsg = "failed to create user: \(error.localizedDescription)"
                return
            }
            
            print("succesfully created new user: \(result?.user.uid ?? "")")
            
            self.logInStatusMsg = "succesfully created new user: \(result?.user.uid ?? "")"
        }
    }
    
    // log in existing account function
    private func logInAccount() {
        Auth.auth().signIn(withEmail: email, password: password) {
            result, error in
            if let error = error {
                print("failed to log in user: \(error.localizedDescription)")
                self.logInStatusMsg = "failed to log in user: \(error.localizedDescription)"
                return
            }
            
            print("succesfully logged in user: \(result?.user.uid ?? "")")
            
            self.logInStatusMsg = "succesfully logged in user: \(result?.user.uid ?? "")"
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}
