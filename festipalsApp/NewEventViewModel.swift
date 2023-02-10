//
//  NewEventViewModel.swift
//  festipalsApp
//
//  Created by sierra jordan on 2/10/23.
//

import Foundation
import FirebaseFirestore
import Firebase

class NewEventViewModel: ObservableObject {
    @Published var event = Event()
    
    func saveEvent(event: Event) async -> Bool {
        let db = Firestore.firestore()
        let uid = Auth.auth().currentUser?.uid ?? ""
        
        if let id = event.id { // update existing event
            do {
                try await db.collection("users").document(uid).collection("events").document(id).setData(event.dictionary)
                print("event updated successfully")
                return true
            } catch {
                print("could not update data in 'events' \(error.localizedDescription)")
                return false
            }
        } else { // create a new event
            do {
                try await db.collection("users").document(uid).collection("events").addDocument(data: event.dictionary)
                print("event added successfully")
                return true
            } catch {
                print("could not create data in 'events' \(error.localizedDescription)")
                return false
            }
        }
    }
}
