//
//  ContentView.swift
//  festipalsApp
//
//  Created by sierra jordan on 2/9/23.
//

import SwiftUI

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
                    .background(.white) // text field background color
                    
                    
                    // create account button
                    Button {
                        signInUp()
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
    }
    
    // log in/sign up function
    private func signInUp() {
        if logInMode {
            // LOG IN TO FIREBASE WITH EXISTING CREDENTIALS
        } else {
            // SIGN UP TO FIREBASE WITH NEW CREDENTIALS
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}
