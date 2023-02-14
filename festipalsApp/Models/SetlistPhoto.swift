//
//  SetlistPhoto.swift
//  festipalsApp
//
//  Created by sierra jordan on 2/14/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct SetlistPhoto: Identifiable, Codable {
    @DocumentID var id: String?
    var imageURLString = ""
    var description = "0"
    
    var dictionary: [String: Any] {
        return ["imageURLString": imageURLString, "description": description]
    }
}
