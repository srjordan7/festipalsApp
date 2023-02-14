//
//  GroupScrollView.swift
//  festipalsApp
//
//  Created by sierra jordan on 2/14/23.
//

import SwiftUI

struct GroupScrollView: View {
    var friends: [Friend]
    var event: Event
    @State var showDeleteOption = false
    @ObservedObject private var friendVM = FriendViewModel()
    @State var selectedFriendId = ""
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(friends) { friend in
                    Text("\(friend.name)")
                        .onTapGesture {
                            selectedFriendId = friend.id ?? ""
                            showDeleteOption.toggle()
                        }
                    Link("\(friend.phoneNumber)", destination: URL(string: "imessage:\(friend.phoneNumber)")!)
                    Divider()
                }
            }
            .actionSheet(isPresented: $showDeleteOption) {
                .init(title: Text("delete friend"), message: Text("are you sure you want to remove this friend?"), buttons: [
                    .destructive(Text("yes"), action: {
                        Task {
                            await friendVM.deleteFriend(event: event, friend: selectedFriendId)
                        }
                    }),
                    .cancel(Text("nevermind"))
                ])
            }
        }
    }
}

struct GroupScrollView_Previews: PreviewProvider {
    static var previews: some View {
        GroupScrollView(friends: [Friend()], event: Event())
//            .environmentObject(FriendViewModel())
    }
}
