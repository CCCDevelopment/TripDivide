//
//  Trip.swift
//  CCCTripSpiltr
//
//  Created by jonathan ferrer on 3/27/20.
//  Copyright © 2020 Ryan Murphy. All rights reserved.
//

import UIKit
import Firebase

class Trip {
    let id: String
    var users: [String]
    var isComplete: Bool
    var name: String
    var totalCost: Double
    let createdBy: String
//    var image: UIImage
    let startDate: Date

    init(id: String = UUID().uuidString, users: [String] = [], isComplete: Bool = false, name: String, totalCost: Double = 0.00, createdBy: String, startDate: Date = Date()) {
        self.id = id
        self.users = [createdBy]
        self.isComplete = isComplete
        self.name = name
        self.totalCost = totalCost
        self.createdBy = createdBy
//        self.image = image
        self.startDate = startDate
    }
    
    init(from dictionary: [String: Any]) {
        self.id = dictionary["id"] as! String
        self.users = dictionary["users"] as! [String]
        self.isComplete = dictionary["isComplete"] as! Bool
        self.name  = dictionary["name"] as! String
        self.totalCost = dictionary["totalCost"] as! Double
        self.createdBy = dictionary["createdBy"] as! String
        //        self.image = image
        
//        let date = postTimestamp.dateValue()
        let date = dictionary["startDate"] as! Timestamp
        self.startDate = date.dateValue()
    }
    
    func dictionaryRep() -> [String : Any] {
        let dictionary: [String : Any] = ["id": id, "users" : users, "isComplete" : isComplete, "name" : name, "totalCost" : totalCost , "createdBy": createdBy, "startDate": startDate]
        return dictionary
    }
}



