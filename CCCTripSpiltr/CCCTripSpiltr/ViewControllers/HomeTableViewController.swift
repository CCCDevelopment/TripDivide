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
    
    
    var trips: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser == nil {
            performSegue(withIdentifier: Constants.Segues.showAuthenticate, sender: nil)
        }
        
        getTrips()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Auth.auth().currentUser != nil {
            getTrips()
        }
    }
    
    func getTrips() {
        NetworkController.shared.getCurrentUser { [weak self] (user, error) in
            guard let self = self else { return }
            
            if let error = error {
                NSLog(error.rawValue)
            }
            guard let user = user else { return }
            
            self.trips = user.trips
            
            self.tableView.reloadData()
        }
    }
    
    @IBAction func addTripButtonPressed(_ sender: Any) {
        
        NetworkController.shared.createTrip(with: "Italy") { (error) in

            if let error = error {
                NSLog(error.rawValue)
                return
            }
            
            self.getTrips()
        }
    }
    
    @IBAction func signOutPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: Constants.Segues.showAuthenticate, sender: nil)
        } catch {
            NSLog("Error signing out")
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        trips.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TripCell", for: indexPath) as! TripCell
        
        let tripID = trips[indexPath.row]
        cell.set(tripID: tripID)
        return cell
    }
    
    
}
