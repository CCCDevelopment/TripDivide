//
//  Expense.swift
//  CCCTripSpiltr
//
//  Created by jonathan ferrer on 4/2/20.
//  Copyright © 2020 Ryan Murphy. All rights reserved.
//

import Foundation
import Firebase

class Expense {
    
    var id: String
    var date: Date
    var name: String
    var cost: Double
    var paidBy: [String: Double]
    var usedBy: [String: Double]
    var reciept: String?
    
    init(id: String = UUID().uuidString, date: Date = Date(), name: String, cost: Double, paidBy: [String: Double], usedBy: [String: Double], recipet: String?) {
        self.id = id
        self.date = date
        self.name = name
        self.cost = cost
        self.paidBy = paidBy
        self.usedBy = usedBy
        self.reciept = recipet
    }
    
    init(from dictionary: [String: Any]) {
        self.id = dictionary["id"] as! String
        let timeStamp = dictionary["startDate"] as! Timestamp
        self.date = timeStamp.dateValue()
        self.name = dictionary["name"] as! String
        self.cost = dictionary["cost"] as! Double
        self.paidBy = dictionary["paidBy"] as! [String: Double]
        self.usedBy = dictionary["usedBy"] as! [String: Double]
        self.reciept = dictionary["reciept"] as? String
        
    }
    
    func dictionaryRep() -> [String : Any?] {
        return ["id": id, "date": date, "name": name, "cost": cost, "paidBy": paidBy, "usedBy": usedBy, "reciept": reciept]
    }
    
}
