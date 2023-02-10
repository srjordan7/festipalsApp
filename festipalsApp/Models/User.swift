//
//  User.swift
//  festipalsApp
//
//  Created by sierra jordan on 2/9/23.
//

import Foundation

struct User {
    let uid, email, profileImageUrl, name: String
    
    init(data: [String: Any]) {
        self.uid = data["uid"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.profileImageUrl = data["profileImageUrl"] as? String ?? ""
        self.name = data["name"] as? String ?? ""
    }
}
