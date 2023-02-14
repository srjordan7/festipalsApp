//
//  VenuePhoto.swift
//  festipalsApp
//
//  Created by sierra jordan on 2/14/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct VenuePhoto: Identifiable, Codable {
    @DocumentID var id: String?
    var imageURLString = ""
    var eodLocation = ""
    
    var dictionary: [String: Any] {
        return ["imageURLString": imageURLString, "eodLocation": eodLocation]
    }
}
