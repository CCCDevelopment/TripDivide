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
    case addingExpenseError = "Error adding Expense"
    case uploadingImageError = "Error uploading image"
    case creatingExpenseError = "Error creating expense"
    case updatingUserError = "Error updating user"
    case updatingExpenseError = "Error updating expense"
    case gettingExpensesError = "Error getting expenses"
    case deletingExpenseError = "Error deleting expense"
}

class NetworkController {
    
    var currentUser: User!
    var trips: [Trip] = []
    let db = Firestore.firestore()
    let storage = Storage.storage()
    static let shared = NetworkController()
    let cache = NSCache<NSString, UIImage>()
    
    func getExpense(expenseID: String, completion: @escaping (Expense?, CCCError?) -> Void) {
        let expenseRef = db.collection("expenses").document(expenseID)
        
        expenseRef.getDocument { (document, _) in
            if let document = document, document.exists {
                guard let data = document.data() else { return }
                let expense = Expense(from: data)
                completion(expense, nil)
            } else {
                completion(nil, .noData)
            }
        }
        
    }
    
    func deleteExpense(tripID: String, expense: Expense, expenseID: String, oldTotal: Double?, completion: @escaping (CCCError?) -> Void) {
        if let oldTotal = oldTotal {
            db.collection("trips").document(tripID).updateData(["totalCost" : FieldValue.increment(-oldTotal)])
        }
        db.collection("trips").document(tripID).updateData(["expenses": FieldValue.arrayRemove([expense.id])])
            
        let expenseRef = db.collection("expenses").document(expenseID)
            expenseRef.delete() { (error) in
            if let _ = error {
                completion(CCCError.deletingExpenseError)
            } else {
                completion(nil)
            }
        }
    }
    
    func addExpenseTo(tripID: String, expense: Expense, oldTotal: Double?, completion: @escaping (CCCError?) -> Void) {
        if let oldTotal = oldTotal {
            db.collection("trips").document(tripID).updateData(["totalCost" : FieldValue.increment(-oldTotal)])
        }
        db.collection("trips").document(tripID).updateData(["totalCost" : FieldValue.increment(expense.cost)])
        
        
        db.collection("trips").document(tripID).updateData(["expenses": FieldValue.arrayUnion([expense.id])]) { (error) in
            if let _ = error {
                completion(CCCError.addingExpenseError)
            }
            completion(nil)
        }
    }
    
    
    
    
    
    func updateExpense(expense: Expense, completion: @escaping (CCCError?) -> Void) {
        let ref = db.collection("expenses")
        ref.document(expense.id).setData(expense.dictionaryRep(), completion: { (error) in
            if let _ = error {
                completion(CCCError.updatingExpenseError)
                return
            }
            completion(nil)
        })
        
    }
    
    func uploadExpense(image: UIImage?, expense: Expense, oldTotal: Double?, tripID: String, completion: @escaping (CCCError?) -> Void) {
        
        guard let image = image,
            let imageData = image.jpegData(compressionQuality: 0.75) else {
                
                
                self.createExpense(expense: expense, oldTotal: oldTotal, tripID: tripID, imageURL: nil) { (error) in
                    if let _ = error {
                        completion(.creatingTripError)
                        return
                    }
                    completion(nil)
                }
                return
        }
        
        let storageRef = storage.reference()
        let imagesFolderRef = storageRef.child("images").child("receiptImages")
        let imageURLRef = imagesFolderRef.child("\(expense.id).jpg")
        imageURLRef.putData( imageData, metadata: nil) { (_, error) in
            
            imageURLRef.downloadURL { (url, error) in
                
                if let _ = error {
                    completion(.uploadingImageError)
                    return
                }
                
                guard let downloadURL = url else {
                    completion(.uploadingImageError)
                    return
                }
                
                
                self.createExpense(expense: expense, oldTotal: oldTotal, tripID: tripID, imageURL: downloadURL.absoluteString) { (error) in
                    if let _ = error {
                        completion(.creatingTripError)
                        return
                    }
                    completion(nil)
                }
            }
        }
    }
    
    func createExpense(expense: Expense, oldTotal: Double?, tripID: String, imageURL: String?, completion: @escaping (CCCError?) -> Void) {
        let expense = expense
        
        expense.receipt = imageURL
        let ref = self.db.collection("expenses")
        ref.document(expense.id).setData(expense.dictionaryRep()) { (error) in
            
            if let _ = error {
                completion(CCCError.creatingExpenseError)
                return
            }
            self.addExpenseTo(tripID: tripID, expense: expense, oldTotal: oldTotal) { (error) in
                completion(error)
            }
            completion(nil)
            
        }
        
    }
    
    
    
    
    
    func uploadTrip(image: UIImage?,name: String, friendIds: [String], completion: @escaping (CCCError?) -> Void) {
        
        guard let image = image,
            let imageData = image.jpegData(compressionQuality: 0.75) else {
                
                
                self.createTrip(with: name, friendIds: friendIds, imageURL: nil) { (error) in
                    if let _ = error {
                        completion(.creatingTripError)
                        return
                    }
                    completion(nil)
                }
                return
        }
        
        let storageRef = storage.reference()
        let imagesFolderRef = storageRef.child("images").child("tripImages")
        let imageURLRef = imagesFolderRef.child("\(UUID().uuidString).jpg")
        imageURLRef.putData( imageData, metadata: nil) { (_, error) in
            
            imageURLRef.downloadURL { (url, error) in
                
                if let _ = error {
                    completion(.uploadingImageError)
                    return
                }
                
                guard let downloadURL = url else {
                    completion(.uploadingImageError)
                    return
                }
                
                
                self.createTrip(with: name, friendIds: friendIds, imageURL: downloadURL.absoluteString) { (error) in
                    if let error = error {
                        print(error)
                        
                        completion(error)
                        
                    }
                    completion(nil)
                }
            }
        }
    }
    
    func createTrip(with name: String, friendIds: [String], imageURL: String? , completion: @escaping (CCCError?) -> Void) {
        
        guard let userID = Auth.auth().currentUser?.uid else {
            completion(.creatingTripError)
            return
        }
        let trip = Trip(users: [userID], name: name, createdBy: userID, image: imageURL)
        trip.users.append(contentsOf: friendIds)
        let ref = self.db.collection("trips")
        
        ref.document(trip.id).setData(trip.dictionaryRep()) { (error) in
            if let _ = error {
                completion(.creatingTripError)
                return
            }
            
            
            self.addTrip(to: userID, tripID: trip.id) { (error) in
                if let _ = error {
                    completion(.addingTripError)
                    return
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
            if let _ = error {
                completion(.addingTripError)
            }
        }
        completion(nil)
        
    }
    
    func createGuest(fullName: String, completion: @escaping (String?,CCCError?) -> Void) {
        
        let user = User(id: UUID().uuidString, username: "guest", fullName: fullName, avatar: nil, email: "guest@tripdivide.com")
        self.db.collection("users").document(user.id).setData(user.dictionaryRep()) { (error) in
            if error != nil {
                completion(nil,.savingError)
            }
        }
        completion(user.id, nil)
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
    
    func updateUser(with image: UIImage?, user: User, completion: @escaping (CCCError?) -> Void) {
        
        guard let image = image,
            let imageData = image.jpegData(compressionQuality: 0.50) else {
                
                
                self.updateUser(user: user) { (error) in
                    if let error = error {
                        NSLog(error.rawValue)
                        completion(.uploadingImageError)
                    }
                }
                completion(nil)
                return
        }
        
        let storageRef = storage.reference()
        let imagesFolderRef = storageRef.child("images").child("avatarImages")
        let imageURLRef = imagesFolderRef.child("\(user.id).jpg")
        imageURLRef.putData( imageData, metadata: nil) { (metadata, error) in
            guard let _ = metadata else {
                completion(.uploadingImageError)
                return
            }
            
            imageURLRef.downloadURL { (url, error) in
                
                if let _ = error {
                    completion(.updatingUserError)
                    return
                }
                
                guard let downloadURL = url else {
                    completion(.uploadingImageError)
                    return
                }
                
                user.avatar = downloadURL.absoluteString
                
                self.updateUser(user: user) { (error) in
                    completion(.updatingUserError)
                    return
                }
                completion(nil)
            }
        }
    }
    
    
    
    func updateUser(user: User, completion: @escaping (CCCError?) -> Void) {
        let ref = db.collection("users")
        ref.document(user.id).setData(user.dictionaryRep(), completion: { (error) in
            if let _ = error {
                completion(CCCError.updatingExpenseError)
                return
            }
            completion(nil)
        })
        
        
        
        
    }
    
    func getCurrentUser(completion: @escaping (User?, CCCError?) -> Void) {
        let ref = db.collection("users")
        
        guard let currentAuthUser = Auth.auth().currentUser else {
            completion(nil, .noData)
            return }
        let userREf = ref.document(currentAuthUser.uid)
        
        userREf.getDocument { (document, error) in
            if let document = document, document.exists {
                guard let data = document.data() else {
                    completion(nil, .noData)
                    return
                    
                }
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
                guard let data = document.data() else {
                    completion(nil, .noData)
                    return }
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
                    let document = snapshot.documents.first else {
                        completion(nil, .noData)
                        return
                }
                
                let user = User(from: document.data())
                completion(user, nil)
            }
        }
    }
}
