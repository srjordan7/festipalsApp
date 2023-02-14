//
//  FriendViewModel.swift
//  festipalsApp
//
//  Created by sierra jordan on 2/14/23.
//

import Foundation
import FirebaseFirestore
import Firebase

class FriendViewModel: ObservableObject {
    @Published var friend = Friend()
    
    func saveFriend(event: Event, friend: Friend) async -> Bool {
        let db = Firestore.firestore()
        let uid = Auth.auth().currentUser?.uid ?? ""
        
        if let id = friend.id { // update existing friend
            do {
                try await db.collection("users").document(uid).collection("events").document(event.id ?? "").collection("friends").document(id).setData(event.dictionary)
//                self.getEventData()
                print("friend updated successfully")
                return true
            } catch {
                print("could not update data in 'friend' \(error.localizedDescription)")
                return false
            }
        } else { // create a new friend
            do {
                try await db.collection("users").document(uid).collection("events").document(event.id ?? "").collection("friends").addDocument(data: friend.dictionary)
//                self.getEventData()
                print("friend added successfully")
                return true
            } catch {
                print("could not create data in 'friend' \(error.localizedDescription)")
                return false
            }
        }
    }
}
