//
//  Trip.swift
//  CCCTripSpiltr
//
//  Created by jonathan ferrer on 3/27/20.
//  Copyright © 2020 Ryan Murphy. All rights reserved.
//

import UIKit

class Trip {
    let id: String
    var users: [String]
    var isComplete: Bool
    var name: String
    var totalCost: Double
    let createdBy: String
//    var image: UIImage
    let startDate: Date
    var endDate: Date?

    init(id: String = UUID().uuidString, isComplete: Bool = false, name: String, totalCost: Double = 0.00, createdBy: String, startDate: Date = Date()) {
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
        self.id = dictionary["uid"] as! String
        self.users = dictionary["users"] as! [String]
        self.isComplete = dictionary["isComplete"] as! Bool
        self.name  = dictionary["name"] as! String
        self.totalCost = dictionary["totalCost"] as! Double
        self.createdBy = dictionary["createdBy"] as! String
        //        self.image = image
        self.startDate = dictionary["startDate"] as! Date
    }
    
    func dictionaryRep() -> [String : Any] {
        return ["uid": id, "users" : users, "isComplete" : isComplete, "name" : name, "totalCost" : totalCost , "users" : users , "createdBy": createdBy, "startDate": startDate]
    }
}



