//
//  Friend.swift
//  festipalsApp
//
//  Created by sierra jordan on 2/14/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct Friend: Identifiable, Codable {
    @DocumentID var id: String?
    var name = ""
    var phoneNumber = ""
    
    var dictionary: [String: Any] {
        return ["name": name, "phoneNumber": phoneNumber]
    }
}
