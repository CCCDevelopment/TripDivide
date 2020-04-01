//
//  HomeViewController.swift
//  CustomLoginDemo
//
//  Created by Christopher Ching on 2019-07-22.
//  Copyright © 2019 Christopher Ching. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class HomeTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser == nil {
            performSegue(withIdentifier: Constants.Segues.showAuthenticate, sender: nil)
        }
        
    }
    
    @IBAction func addTripButtonPressed(_ sender: Any) {
        
        let vc = AddFriendVC()
        
        
        present(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func signOutPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: Constants.Segues.showAuthenticate, sender: nil)
        } catch {
            NSLog("Error signing out")
        }
    }
    
    
}
