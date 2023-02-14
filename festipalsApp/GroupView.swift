//
//  GroupView.swift
//  festipalsApp
//
//  Created by sierra jordan on 2/14/23.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct GroupView: View {
    @State var selectedTab: Tabs = .group
    @State var event: Event
    @State private var showAddFriendSheet = false
    @FirestoreQuery(collectionPath: "users/\(Auth.auth().currentUser?.uid ?? "")/events") var friends: [Friend]
    var previewRunning = false
    
    var body: some View {
        NavigationView {
            VStack {
                Text("group")
                Spacer()
                
                ScrollView {
                    ForEach(friends) { friend in
                        Text("\(friend.name)")
                        Link("\(friend.phoneNumber)", destination: URL(string: "imessage:\(friend.phoneNumber)")!)
//                        Text("\(friend.phoneNumber)")
                        Divider()
                    }
                }
                
                Spacer()
                
                EventTabBar(selectedTab: $selectedTab, event: event)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination: AllEventsView()) {
                        Text("events")
                            .foregroundColor(.green)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showAddFriendSheet.toggle()
                    } label: {
                        Image(systemName: "plus")
                            .foregroundColor(.green)
                    }

                }
            }
            .background(Color("BackgroundColor")
                            .ignoresSafeArea()) // background color
        }
        .onAppear {
            if !previewRunning {
                $friends.path = "users/\(Auth.auth().currentUser?.uid ?? "")/events/\(event.id ?? "")/friends"
            }
        }
        .sheet(isPresented: $showAddFriendSheet) {
            AddFriendView(event: event, friend: Friend())
        }
        .navigationBarBackButtonHidden()
    }
}

struct GroupView_Previews: PreviewProvider {
    static var previews: some View {
        GroupView(event: Event(), previewRunning: true)
    }
}
