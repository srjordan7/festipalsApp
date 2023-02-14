//
//  AddFriendView.swift
//  festipalsApp
//
//  Created by sierra jordan on 2/14/23.
//

import SwiftUI

struct AddFriendView: View {
    @State var event: Event
    @State var friend: Friend
    @EnvironmentObject var friendVM: FriendViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Text("who's going with?")
                
                Group {
                    TextField("name", text: $friend.name)
                    TextField("phone number", text: $friend.phoneNumber)
                }
                .padding(.horizontal)
                
                Spacer()
                
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("cancel")
                            .foregroundColor(.green)
                    }

                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        Task {
                            let success = await friendVM.saveFriend(event: event, friend: friend)
                            if success {
                                dismiss()
                            }
                        }
                    } label: {
                        Text("save")
                            .foregroundColor(.green)
                    }

                }
            }
            .background(Color("BackgroundColor")
                .ignoresSafeArea()) // background color
        }
        .navigationBarBackButtonHidden()
    }
}

struct AddFriendView_Previews: PreviewProvider {
    static var previews: some View {
        AddFriendView(event: Event(), friend: Friend())
            .environmentObject(FriendViewModel())
    }
}
