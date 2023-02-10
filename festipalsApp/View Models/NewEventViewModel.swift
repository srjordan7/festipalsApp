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
    @Published var events = [Event]()
    
    func saveEvent(event: Event) async -> Bool {
        let db = Firestore.firestore()
        let uid = Auth.auth().currentUser?.uid ?? ""
        
        if let id = event.id { // update existing event
            do {
                try await db.collection("users").document(uid).collection("events").document(id).setData(event.dictionary)
                self.getEventData()
                print("event updated successfully")
                return true
            } catch {
                print("could not update data in 'events' \(error.localizedDescription)")
                return false
            }
        } else { // create a new event
            do {
                try await db.collection("users").document(uid).collection("events").addDocument(data: event.dictionary)
                self.getEventData()
                print("event added successfully")
                return true
            } catch {
                print("could not create data in 'events' \(error.localizedDescription)")
                return false
            }
        }
    }
    
    func getEventData() {
        let db = Firestore.firestore()
        let uid = Auth.auth().currentUser?.uid ?? ""
        
        db
            .collection("users")
            .document(uid)
            .collection("events")
            .order(by: "firstDay")
            .getDocuments { snapshot, error in
            if error == nil {
                if let snapshot = snapshot {
                    DispatchQueue.main.async {
                        self.events = snapshot.documents.map { document in
                            return Event(id: document.documentID, eventName: document["eventName"] as? String ?? "", venue: document["venue"] as? String ?? "", multiDay: document["multiDay"] as? Bool ?? false, firstDay: document["firstDay"] as? Date ?? Date(), firstDayString: document["firstDayString"] as? String ?? "", lastDay: document["lastDay"] as? Date ?? Date(), lastDayString: document["lastDayString"] as? String ?? "")
                        }
                    }
                }
            } else {
                print("failed")
            }
        }
    }
}
