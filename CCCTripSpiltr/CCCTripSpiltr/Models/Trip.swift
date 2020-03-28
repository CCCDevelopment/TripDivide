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
//    var image: UIImage
    let startDate: Date
    var endDate: Date?

    init(id: String = UUID().uuidString, users: [String], isComplete: Bool = false, name: String, startDate: Date = Date()) {
        self.id = id
        self.users = users
        self.isComplete = isComplete
        self.name = name
//        self.image = image
        self.startDate = startDate
    }
    
    func dictionaryRep() -> [String : Any] {
        return ["id": id, "users" : users, "isComplete" : isComplete, "name" : name, "startDate": startDate]
    }
}



