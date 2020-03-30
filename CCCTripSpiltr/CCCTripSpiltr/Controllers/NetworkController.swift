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
import FirebaseAuth


enum CCCError: String {
    case creatingUserError = "Error creating user"
    case savingError = "Error saving user data"
    case noData = "Document does not exist"
    case creatingTripError = "Error creating trip"
}

class NetworkController {
    var trips: [Trip] = []
    let db = Firestore.firestore()
    static let shared = NetworkController()
    
    func createUser(email: String, password: String, fullName: String, username: String, completion: @escaping (CCCError?) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
            
            // Check for errors
            if err != nil {
                
                // There was an error creating the user
                completion(.creatingUserError)
            }
            else {
                guard let id = Auth.auth().currentUser?.uid else { return }
                // User was created successfully, now store the first name and last name
                let user = User(id: id, username: username, fullName: fullName, avatar: nil, email: email)
                self.db.collection("users").document(result!.user.uid).setData(user.dictionaryRep()) { (error) in
                    if error != nil {
                        completion(.savingError)
                    }
                }
                completion(nil)
            }
        }
    }
    
    
    func createTrip(with name: String, completion: @escaping (CCCError?) -> Void) {
       
        
        
        getCurrentUser { (user, error) in
            if let _ = error {
                completion(.creatingTripError)
            }
            guard let user = user else { return }
            let trip = Trip(users: [user.id], name: name)
            let ref = self.db.collection("trips")
            
            ref.document(trip.id).setData(trip.dictionaryRep()) { (error) in
                if let _ = error {
                    completion(.creatingTripError)
                }
                completion(nil)
            }
            
        }
        
        
    }
    
    func getCurrentUser(completion: @escaping (User?, CCCError?) -> Void) {
        let ref = db.collection("users")
        
        guard let currentAuthUser = Auth.auth().currentUser else { return }
        let userREf = ref.document(currentAuthUser.uid)
        
        userREf.getDocument { (document, _) in
            if let document = document, document.exists {
                guard let data = document.data() else { return }
                let user = User(from: data)
                completion(user, nil)
            } else {
                completion(nil, .noData)
            }
        }
    }
    
}
