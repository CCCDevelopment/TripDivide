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
    var imageURL: String?
    let startDate: Date
//    var expenses: [Expense]

    init(id: String = UUID().uuidString, users: [String] = [], isComplete: Bool = false, name: String, totalCost: Double = 0.00, createdBy: String, image: String?, startDate: Date = Date()){
        self.id = id
        self.users = [createdBy]
        self.isComplete = isComplete
        self.name = name
        self.totalCost = totalCost
        self.createdBy = createdBy
        self.imageURL = image
        self.startDate = startDate
//        self.expenses = expenses
    }
    
    init(from dictionary: [String: Any]) {
        self.id = dictionary["id"] as! String
        self.users = dictionary["users"] as! [String]
        self.isComplete = dictionary["isComplete"] as! Bool
        self.name  = dictionary["name"] as! String
        self.totalCost = dictionary["totalCost"] as! Double
        self.createdBy = dictionary["createdBy"] as! String
        self.imageURL = dictionary["imageURL"] as? String
        
        let date = dictionary["startDate"] as! Timestamp
        self.startDate = date.dateValue()
//        let dictArray = dictionary["expenses"] as! [[String: Any]]
//        var expenseArray = [Expense]()
//        for dict in dictArray {
//            let expense = Expense(from: dict)
//            expenseArray.append(expense)
//        }

//        self.expenses = expenseArray
    }
    
    func dictionaryRep() -> [String : Any] {
        let dictionary: [String : Any] = ["id": id, "users" : users, "isComplete" : isComplete, "name" : name, "totalCost" : totalCost , "createdBy": createdBy, "imageURL": imageURL as Any, "startDate": startDate]
        return dictionary
    }
}



