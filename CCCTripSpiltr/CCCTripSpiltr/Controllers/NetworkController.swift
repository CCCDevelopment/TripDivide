//
//  NetworkController.swift
//  CCCTripSpiltr
//
//  Created by jonathan ferrer on 3/27/20.
//  Copyright © 2020 Ryan Murphy. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase


enum CCCError: String {
    case creatingError = "Error creating user"
    case savingError = "Error saving user data"
}

class NetworkController {
    
    static let shared = NetworkController()
    
    func createUser(email: String, password: String, fullName: String, username: String, completion: @escaping (CCCError?) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
            
            // Check for errors
            if err != nil {
                
                // There was an error creating the user
                completion(.creatingError)
            }
            else {
                
                // User was created successfully, now store the first name and last name
                let db = Firestore.firestore()
                db.collection("users").addDocument(data: ["fullName":fullName, "username":username, "uid": result!.user.uid ]) { (error) in
                    
                    
                    if error != nil {
                        completion(.savingError)
                    }
                }
                completion(nil)
            }
        }
    }
    
    
    func createTrip() {
        
    }

}
