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
    var firstDayString = ""
    var lastDay = Date()
    var lastDayString = ""
    var setlistImgUrl = ""
    
    var dictionary: [String: Any] {
        return ["eventName": eventName, "venue": venue, "multiDay": multiDay, "firstDay": firstDay, "firstDayString": dateToString(date: firstDay), "lastDay": lastDay, "lastDayString": dateToString(date: lastDay), "setlistImgUrl": setlistImgUrl]
    }
    
    func dateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, y"
        let stringDate = dateFormatter.string(from: date)
        return stringDate
    }
}
