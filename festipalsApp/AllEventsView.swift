//
//  AllEventsView.swift
//  festipalsApp
//
//  Created by sierra jordan on 2/9/23.
//

import SwiftUI
import Firebase

struct User {
    let uid, email, profileImageUrl, name: String
}

class AllEventsViewModel: ObservableObject {
    
    @Published var errorMsg = ""
    @Published var user: User?
    
    init() {
        fetchCurrentUser()
    }
    
    // get current user data
    private func fetchCurrentUser() {
        guard let uid = Auth.auth().currentUser?.uid else {
            self.errorMsg = "could not find user data"
            return }
        
        Firestore.firestore().collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                self.errorMsg = "failed to fetch current user: \(error.localizedDescription)"
                print("failed to fetch current user: \(error.localizedDescription)")
                return
            }
            
            guard let data = snapshot?.data() else {
                self.errorMsg = "no data found"
                return }
            
            // build User from data
            let uid = data["uid"] as? String ?? ""
            let email = data["email"] as? String ?? ""
            let profileImageUrl = data["profileImageUrl"] as? String ?? ""
            let name = data["name"] as? String ?? ""
            self.user = User(uid: uid, email: email, profileImageUrl: profileImageUrl, name: name)
        }
    }
    
}

struct AllEventsView: View {
    @State var showLogOutOptions = false
    
    @ObservedObject private var vm = AllEventsViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                // navigation bar
                VStack {
                    HStack {
                        // current account picture
                        AsyncImage(url: URL(string: vm.user?.profileImageUrl ?? "")) { returnedImage in
                            returnedImage
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .clipped()
                                .cornerRadius(50)
                        } placeholder: {
                            Image(systemName: "person")
                        }

                        Spacer()
                        // log out button
                        Button {
                            showLogOutOptions.toggle()
                        } label: {
                            Text("log out")
                                .foregroundColor(.green)
                        }
                    }
                    .padding()
                    .actionSheet(isPresented: $showLogOutOptions) {
                        .init(title: Text("log out"), message: Text("are you sure you want to log out?"), buttons: [
                            .destructive(Text("yes"), action: {
                                // ADD LOG OUT FUNCTIONALITY
                            }),
                            .cancel(Text("nevermind"))
                        ])
                    }
                    
                    Text("hi, \(vm.user?.name ?? "")!")
                    Text("upcoming events")
                        .font(.system(size: 26))
                }
                .padding(.bottom, 30)

                // list of events
                ScrollView {
                    ForEach(0..<5, id: \.self) { num in
                        // single event container
                        HStack {
                            VStack {
                                Text("event name")
                                    .font(.system(size: 22))
                                Text("venue")
                                Text("# days left")
                            }
                        }
                        Divider()
                            .padding(.vertical, 40)
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 50)
            }
            .overlay(
                // new event button
                Button {
                    
                } label: {
                    HStack {
                        Spacer()
                        Text("+ new event")
                        Spacer()
                    }
                    .foregroundColor(.white) // button text color
                    .padding(.vertical)
                    .background(Color.green) // button color
                    .cornerRadius(42)
                    .padding(.horizontal)
                    .shadow(radius: 5)
                }, alignment: .bottom)
            .navigationBarHidden(true)
            .background(Color("BackgroundColor")
                .ignoresSafeArea()) // background color
        }
    }
}

struct AllEventsView_Previews: PreviewProvider {
    static var previews: some View {
        AllEventsView()
    }
}
