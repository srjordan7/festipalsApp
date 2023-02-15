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
    @ObservedObject var friendVM = FriendViewModel()
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Text("who's going with?")
                    .font(.custom("Righteous-Regular", size: 30))
                    .foregroundColor(Color("MainColor"))
                
                Group {
                    TextField("name", text: $friend.name)
                        .font(.custom("SofiaSans-Regular", size: 24))
                    TextField("phone number", text: $friend.phoneNumber)
                }
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .font(.custom("SofiaSans-Regular", size: 18))
                .padding(5)
                .overlay {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.gray.opacity(0.5), lineWidth: 2)
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
                            .font(.custom("SofiaSans-Regular", size: 18))
                            .foregroundColor(Color("MainColor"))
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
                            .font(.custom("SofiaSans-Regular", size: 18))
                            .foregroundColor(Color("MainColor"))
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
