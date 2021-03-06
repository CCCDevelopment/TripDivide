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

class TripsTableVC: UITableViewController {
    
    
    var trips: [String] = []
    var editTrip: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser == nil {
            performSegue(withIdentifier: Constants.Segues.showAuthenticate, sender: nil)
        }
        
        getTrips()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

            getTrips()
        
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
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editButton = UIContextualAction(style: .normal, title: "Edit") { (action, view, actionPerformed) in
            self.editTrip = self.trips[indexPath.row]
            self.performSegue(withIdentifier: "EditTripVCSegue", sender: self)
            
        }
        editButton.backgroundColor = .systemYellow
     
        return UISwipeActionsConfiguration(actions: [editButton])
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "EditTripVCSegue" {
                   let destinationVC = segue.destination as? TripEditVC
                   destinationVC?.tripID = editTrip
                   
               }
        
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        let trip = trips[indexPath.row]
        
        if segue.identifier == "TripDetailSegue" {
            let destinatioVC = segue.destination as? TripDetailTableVC
            destinatioVC?.tripID = trip
        }
        
       
        
    }




    
}
