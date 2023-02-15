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
                    .font(.custom("Righteous-Regular", size: 30))
                    .padding(25)
                    .foregroundColor(Color("MainColor"))
                
                Spacer()
                ZStack {
                    Text("add some friends!")
                        .font(.custom("SofiaSans-Regular", size: 18))
                    
                    GroupScrollView(friends: friends, event: event)
                }
                
                
                Spacer()
                
                EventTabBar(selectedTab: $selectedTab, event: event)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination: AllEventsView()) {
                        Text("events")
                            .font(.custom("SofiaSans-Regular", size: 18))
                            .foregroundColor(Color("MainColor"))
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showAddFriendSheet.toggle()
                    } label: {
                        Image(systemName: "plus")
                            .foregroundColor(Color("MainColor"))
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
