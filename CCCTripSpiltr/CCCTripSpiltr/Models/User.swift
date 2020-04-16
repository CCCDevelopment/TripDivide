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
    var avatar: String?
    var email: String
    var friends: [String]
    var trips: [String]
    init(id: String = UUID().uuidString, username: String, fullName: String, avatar: String?, email: String, friends: [String] = [], trips: [String] = []) {
        self.id = id
        self.username = username
        self.fullName = fullName
        self.avatar = avatar
        self.email = email
        self.friends = friends
        self.trips = trips
    }
    
    init(from dictionary: [String: Any?]) {
        
        self.id = dictionary["id"] as! String
        self.username = dictionary["username"] as! String
        self.fullName = dictionary["fullName"] as! String
        self.email = dictionary["email"] as! String
        self.friends = dictionary["friends"] as! [String]
        self.trips = dictionary["trips"] as! [String]
        self.avatar = dictionary["avatar"] as? String
    }
    
    func dictionaryRep() -> [String : Any] {
        return ["id": id, "username": username, "fullName": fullName, "email": email, "friends": friends, "trips": trips, "avatar": avatar as Any]
    }
}
