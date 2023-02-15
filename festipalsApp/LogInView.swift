//
//  ContentView.swift
//  festipalsApp
//
//  Created by sierra jordan on 2/9/23.
//

import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore
import FirebaseFirestoreSwift

struct LogInView: View {
//    let completeLoginProcess: () -> ()
    
    // log in/sign up picker
    @State private var logInMode = false
    // email/pass field variables
    @State private var email = ""
    @State private var password = ""
    @State private var name = ""
    // image picker
    @State private var showImagePicker = false
    @State private var image: UIImage?
    
    @State private var loggedIn = false
        
    var body: some View {
        NavigationView {
            VStack {
                Spacer(minLength: 75)
                
                Text("festipals")
                    .font(.custom("Righteous-Regular", size: 48))
                    .foregroundColor(Color("MainColor"))
                    .padding(.bottom)
                
                Text(logInMode ? "log in" : "create account")
                    .font(.custom("SofiaSans-Regular", size: 22))
                
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
                                showImagePicker.toggle()
                            } label: {
                                VStack {
                                    if let image = self.image {
                                        Image(uiImage: image)
                                            .resizable()
                                            .frame(width: 96, height: 96)
                                            .scaledToFill()
                                            .cornerRadius(64)
                                    } else {
                                        Image(systemName: "person")
                                            .font(.system(size: 34))
                                            .padding()
                                            .foregroundColor(Color("MainColor")) // default person image color
                                    }
                                }
                            }
                        }
                        
                        // email/pass entry
                        Group {
                            if !logInMode {
                                TextField("name", text: $name)
                            }
                            TextField("email", text: $email)
                                .keyboardType(.emailAddress)
                            SecureField("password", text: $password)
                        }
                        .font(.custom("SofiaSans-Regular", size: 18))
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .padding(12)
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.gray.opacity(0.5), lineWidth: 2)
                        }
                        
                        // create account button
                        Button {
                            signInUp()
                            // ADD ALERT FOR ERRORS
                        } label: {
                            HStack {
                                Spacer()
                                Text(logInMode ? "log in" : "create account")
                                    .font(.custom("SofiaSans-Regular", size: 18))
                                    .foregroundColor(.white) // button text color
                                    .padding(.vertical, 10)
                                Spacer()
                            }
                            .background(Color("MainColor")) // button background color
                            .cornerRadius(15)
                        }
                        
                    }
                    .padding()
                }
                
            }
            .background(Color("BackgroundColor")
                                .ignoresSafeArea())// background color
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .fullScreenCover(isPresented: $showImagePicker) {
            ImagePicker(image: $image)
                .tint(Color("MainColor"))
        }
        .fullScreenCover(isPresented: $loggedIn) {
            AllEventsView()
        }
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
        if self.image == nil {
            self.logInStatusMsg = "you must select an avatar image"
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) {
            result, error in
            if let error = error {
                print("failed to create user: \(error.localizedDescription)")
                self.logInStatusMsg = "failed to create user: \(error.localizedDescription)"
                return
            }
            
            print("succesfully created new user: \(result?.user.uid ?? "")")
            
            self.logInStatusMsg = "succesfully created new user: \(result?.user.uid ?? "")"
            
            self.saveProfileImage()
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
            
            loggedIn.toggle()
        }
    }
    
    // store profile image function
    private func saveProfileImage() {
        guard let uid = Auth.auth().currentUser?.uid else { return
        }
        
        let ref = Storage.storage().reference().child("profilePics/\(uid).jpeg")
//        (withPath: uid)
        guard let imageData = self.image?.jpegData(compressionQuality: 0.5) else { return }
        ref.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                self.logInStatusMsg = "failed to push image to storage: \(error.localizedDescription)"
                print("failed to push image to storage: \(error.localizedDescription)")
                return
            }
            
            ref.downloadURL { url, error in
                if let error = error {
                    self.logInStatusMsg = "failed to retrieve download url: \(error.localizedDescription)"
                    print("failed to retrieve download url: \(error.localizedDescription)")
                    return
                }
                self.logInStatusMsg = "successfully stored image with url: \(url?.absoluteString ?? "")"
                print("successfully stored image with url: \(url?.absoluteString ?? "")")
                
                guard let url = url else { return }
                storeUserInfo(profileImageUrl: url)
            }
        }
    }
    
    // create/access user in users collection
    private func storeUserInfo(profileImageUrl: URL) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let userData = ["email": self.email, "uid": uid, "profileImageUrl": profileImageUrl.absoluteString, "name": self.name]
        
        Firestore.firestore().collection("users")
            .document(uid).setData(userData) { error in
                if let error = error {
                    print(error.localizedDescription)
                    self.logInStatusMsg = "\(error.localizedDescription)"
                    return
                }
                
                print("success")
                
                loggedIn.toggle()
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}
