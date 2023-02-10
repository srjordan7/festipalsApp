//
//  Event.swift
//  festipalsApp
//
//  Created by sierra jordan on 2/10/23.
//

import Foundation
import FirebaseFirestoreSwift

struct Event: Identifiable, Codable {
    @DocumentID var id: String?
    var eventName = ""
    var venue = ""
    var multiDay = false
    var firstDay = Date()
    var lastDay = Date()
    
    var dictionary: [String: Any] {
        return ["eventName": eventName, "venue": venue, "multiDay": multiDay, "firstDay": firstDay, "last day": lastDay]
    }
}
