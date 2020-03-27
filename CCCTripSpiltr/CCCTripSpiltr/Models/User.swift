//
//  User.swift
//  CCCTripSpiltr
//
//  Created by jonathan ferrer on 3/27/20.
//  Copyright © 2020 Ryan Murphy. All rights reserved.
//

import UIKit

class User {
    let id: UUID
    var username: String
    var fullName: String
    var avatar: UIImage
    
    init(id: UUID = UUID(), username: String, fullName: String, avatar: UIImage) {
        self.id = id
        self.username = username
        self.fullName = fullName
        self.avatar = avatar
    }
}
