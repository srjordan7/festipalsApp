//
//  NewEventViewModel.swift
//  festipalsApp
//
//  Created by sierra jordan on 2/10/23.
//

import Foundation
import FirebaseFirestore
import Firebase
import FirebaseStorage
import UIKit

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
    
    func saveSetlistImage(event: Event, setlistPhoto: SetlistPhoto, image: UIImage) async -> Bool {
        guard let eventId = event.id else {
            print("event.id == nil")
            return false
        }
        
        let setlistPhotoName = UUID().uuidString
        let storage = Storage.storage()
        let storageRef = storage.reference().child("\(eventId)/setlistPics/\(setlistPhotoName).jpeg")
        
        guard let resizedSetlistImage = image.jpegData(compressionQuality: 0.5) else {
            print("could not resize image")
            return false
        }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        var setlistImageURLString = ""
        
        do {
            let _ = try await storageRef.putDataAsync(resizedSetlistImage, metadata: metadata)
            print("image saved")
            do {
                let setlistImageURL = try await storageRef.downloadURL()
                setlistImageURLString = "\(setlistImageURL)"
            } catch {
                print("could not get URL after saving image \(error.localizedDescription)")
            }
        } catch {
            print("error uploading image to storage")
            return false
        }
        
        let db = Firestore.firestore()
        let uid = Auth.auth().currentUser?.uid ?? ""
        
        do {
            var newSetlistPhoto = setlistPhoto
            newSetlistPhoto.imageURLString = setlistImageURLString
            try await db.collection("users").document(uid).collection("events").document(eventId).collection("setlistPhotos").document(setlistPhotoName).setData(newSetlistPhoto.dictionary)
            print("data updated successfully")
            return true
        } catch {
            print("could not update data in setlistPhotos")
            return false
        }
    }
    
    func deleteSetlistImage(event: Event, setlist: String) async -> Bool {
        let db = Firestore.firestore()
        let uid = Auth.auth().currentUser?.uid
        guard let eventId = event.id else {
            print("could not find event.id")
            return false
        }
        
        do {
            let _ = try await db.collection("users").document(uid ?? "").collection("events").document(eventId).collection("setlistPhotos").document(setlist).delete()
            print("setlist successfully deleted")
            return true
        } catch {
            print("error deleting setlist \(error.localizedDescription)")
            return false
        }
    }
}
