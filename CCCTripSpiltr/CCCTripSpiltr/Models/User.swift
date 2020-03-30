//
//  User.swift
//  CCCTripSpiltr
//
//  Created by jonathan ferrer on 3/27/20.
//  Copyright © 2020 Ryan Murphy. All rights reserved.
//

import UIKit

class User {
    let id: String
    var username: String
    var fullName: String
    var avatar: UIImage?
    var email: String
    init(id: String = UUID().uuidString, username: String, fullName: String, avatar: UIImage?, email: String) {
        self.id = id
        self.username = username
        self.fullName = fullName
        self.avatar = avatar
        self.email = email
    }
    
    init(from dictionary: [String: Any?]) {
        
        self.id = dictionary["uid"] as! String
        self.username = dictionary["username"] as! String
        self.fullName = dictionary["fullName"] as! String
        self.email = dictionary["email"] as! String
    }
    
    func dictionaryRep() -> [String : Any] {
        return ["id": id, "username": username, "fullName": fullName, "email": email]
    }
}
