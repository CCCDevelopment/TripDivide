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
    
    init(id: String = UUID().uuidString, username: String, fullName: String, avatar: UIImage) {
        self.id = id
        self.username = username
        self.fullName = fullName
        self.avatar = avatar
    }
    
    init(from dictionary: [String: Any?]) {
        
        self.id = dictionary["uid"] as! String
        self.username = dictionary["username"] as! String
        self.fullName = dictionary["fullName"] as! String
    }
}
