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
    case addingFriendError = "Error adding friend"
    case addingTripError = "Error adding trip"
}

class NetworkController {
    
    var currentUser: User!
    var trips: [Trip] = []
    let db = Firestore.firestore()
    static let shared = NetworkController()
    
    func createTrip(with name: String, completion: @escaping (CCCError?) -> Void) {
        
        guard let userID = Auth.auth().currentUser?.uid else {
            completion(.creatingTripError)
            return
        }
        
        let trip = Trip( users: [userID], isComplete: false, name: "Italy", totalCost: 12.40, createdBy: userID, startDate: Date())
        let ref = self.db.collection("trips")
        
        ref.document(trip.id).setData(trip.dictionaryRep()) { (error) in
            if let _ = error {
                completion(.creatingTripError)
            }
            
            
            self.addTrip(to: userID, tripID: trip.id) { (error) in
                if let _ = error {
                    completion(.addingTripError)
                }
                
                completion(nil)
                
            }
            
            
            
        }
        
        
    }
    
    func getTrip(for id: String, completion: @escaping (Trip?, CCCError?) -> Void) {
        let tripsRef = db.collection("trips")
        
        let tripDocumentRef = tripsRef.document(id)
        
        tripDocumentRef.getDocument { (document, _) in
            if let document = document, document.exists {
                guard let data = document.data() else { return }
                let trip = Trip(from: data)
                completion(trip, nil)
            } else {
                completion(nil, .noData)
            }
        }
        
    }
    
    func addTrip(to userID: String, tripID: String, completion: @escaping (CCCError?) -> Void) {
        let userRef = db.collection("users").document(userID)
        
        userRef.updateData(["trips": FieldValue.arrayUnion([tripID])]) { (error) in
            completion(.addingTripError)
        }
        completion(nil)
        
    }
    
    
    func createUser(email: String, password: String, fullName: String, username: String, completion: @escaping (CCCError?) -> Void) {
        let email = email.lowercased()
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
    
    
    
    func getCurrentUser(completion: @escaping (User?, CCCError?) -> Void) {
        let ref = db.collection("users")
        
        guard let currentAuthUser = Auth.auth().currentUser else { return }
        let userREf = ref.document(currentAuthUser.uid)
        
        userREf.getDocument { (document, _) in
            if let document = document, document.exists {
                guard let data = document.data() else { return }
                let user = User(from: data)
                self.currentUser = user
                completion(user, nil)
            } else {
                completion(nil, .noData)
            }
        }
    }
    
    func getUser(for id: String, completion: @escaping (User?, CCCError?) -> Void) {
        let usersRef = db.collection("users")
        
        let userDocument = usersRef.document(id)
        
        userDocument.getDocument { (document, _) in
            if let document = document, document.exists {
                guard let data = document.data() else { return }
                let user = User(from: data)
                completion(user, nil)
            } else {
                completion(nil, .noData)
            }
        }
        
    }
    
    func add(friend: String, completion: @escaping (CCCError?) -> Void) {
        
        guard let userID = Auth.auth().currentUser?.uid else {
            completion( CCCError.addingFriendError)
            return
        }
        
        db.collection("users").document(userID).updateData(["friends": FieldValue.arrayUnion([friend])]) { (error) in
            if let _ = error {
                completion(CCCError.addingFriendError)
            }
            completion(nil)
        }
    }
    
    func search(email: String, completion: @escaping (User?, CCCError?) -> Void) {
        let usersRef = db.collection("users")
        
        let query = usersRef.whereField("email", isEqualTo: email)
        
        query.getDocuments() { (querySnapshot, err) in
            if let _ = err {
                completion(nil, .noData)
            } else {
                guard let snapshot = querySnapshot,
                    let document = snapshot.documents.first else { return }
                
                let user = User(from: document.data())
                completion(user, nil)
            }
        }
    }
}
