//
//  AllEventsView.swift
//  festipalsApp
//
//  Created by sierra jordan on 2/9/23.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct UserEvent: Identifiable {
    var id: String { documentId }
    let documentId: String
    let eventName, venue: String
    let multiDay: Bool
    let firstDay, lastDay: Any
    
    init(documentId: String, data: [String: Any]) {
        self.documentId = documentId
        self.eventName = data["eventName"] as? String ?? ""
        self.venue = data["venue"] as? String ?? ""
        self.multiDay = data["multiDay"] as? Bool != nil
        self.firstDay = data["firstDay"]
        self.lastDay = data["lastDay"]
    }
}

class AllEventsViewModel: ObservableObject {
    
    @Published var errorMsg = ""
    @Published var user: User?
    
    @Published var userEvents = [UserEvent]()
    
    init() {
        DispatchQueue.main.async {
            self.currentlyLoggedOut = Auth.auth().currentUser?.uid == nil
        }
        
        fetchCurrentUser()
        fetchUserEvents()
    }
    
    // get current user data
    func fetchCurrentUser() {
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
            self.user = .init(data: data)
        }
    }
    
    @Published var currentlyLoggedOut = false
    
    func signOut() {
        currentlyLoggedOut.toggle()
        try? Auth.auth().signOut()
    }
    
    private func fetchUserEvents() {
        let uid = Auth.auth().currentUser?.uid ?? ""
        Firestore.firestore().collection("users").document(uid).collection("events").addSnapshotListener { querySnapshot, error in
            if let error = error {
                self.errorMsg = "failed to listen for events: \(error.localizedDescription)"
                print(error)
                return
            }
            
            querySnapshot?.documentChanges.forEach({ change in
                if change.type == .added {
                    let data = change.document.data()
                    let userEvent = UserEvent(documentId: change.document.documentID, data: data)
                    self.userEvents.append(userEvent)
                }
            })
        }
    }
    
}

struct AllEventsView: View {
    @FirestoreQuery(collectionPath: "users/\( Auth.auth().currentUser?.uid ?? "")/events") var events: [Event]
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
                    // log out confirmation sheet
                    .actionSheet(isPresented: $showLogOutOptions) {
                        .init(title: Text("log out"), message: Text("are you sure you want to log out?"), buttons: [
                            .destructive(Text("yes"), action: {
                                vm.signOut()
                            }),
                            .cancel(Text("nevermind"))
                        ])
                    }
                    .fullScreenCover(isPresented: $vm.currentlyLoggedOut, onDismiss: nil) {
                        LogInView(completeLoginProcess: {
                            self.vm.currentlyLoggedOut = false
                            self.vm.fetchCurrentUser()
                        })
                    }
                    
                    // personalized heading
                    Text("hi, \(vm.user?.name ?? "")!")
                    Text("upcoming events")
                        .font(.system(size: 26))
                }
                .padding(.bottom, 30)

                // list of events
                ScrollView {
                    ForEach(vm.userEvents) { event in
                        // single event container
                        NavigationLink(destination: EventHomeView(event: event)) {
                            VStack {
                                Text(event.eventName)
                                    .font(.system(size: 22))
                                Text(event.venue)
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
                newEventButton, alignment: .bottom)
            .navigationBarHidden(true)
            .background(Color("BackgroundColor")
                .ignoresSafeArea()) // background color
        }
    }
    
    @State var showNewEventScreen = false
    
    // new event button
    private var newEventButton: some View {
        Button {
            showNewEventScreen.toggle()
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
        }
        .fullScreenCover(isPresented: $showNewEventScreen) {
            NewEventView(event: Event())
        }
    }
}

struct AllEventsView_Previews: PreviewProvider {
    static var previews: some View {
        AllEventsView()
    }
}
