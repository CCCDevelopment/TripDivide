//
//  TripDetailTableViewController.swift
//  CCCTripSpiltr
//
//  Created by jonathan ferrer on 4/1/20.
//  Copyright © 2020 Ryan Murphy. All rights reserved.
//

import UIKit

class TripDetailTableViewController: UITableViewController {
    
    
    var tripID: String?
    var trip: Trip?
    
    @IBOutlet weak var containerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getTrip()
        
    }
    
    @IBOutlet weak var tripImageView: UIImageView!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var borrowedLabel: UILabel!
    @IBOutlet weak var owedLabel: UILabel!
    @IBOutlet weak var userAvatarCollectionView: UICollectionView!
    
    func getTrip() {
        guard let tripID = tripID else { return }
        NetworkController.shared.getTrip(for: tripID) { [weak self] (trip, error) in
            guard let self = self else { return }
            if let error = error {
                NSLog(error.rawValue)
                return
            }
            
            guard let trip = trip else { return }
            self.trip = trip
            self.configureViews()
        }
    }
    
    func configureViews () {
        guard let trip = trip else { return }
        containerView.showLoadingView()
   
        if let image = trip.imageURL {
            UIImage().downloadImage(from: image) { (tripImage) in
                guard let tripImage = tripImage else { return }
                
                DispatchQueue.main.async {
                    self.containerView.dismissLoadingView()
                    self.tripImageView.image = tripImage
                }
            }
        } else {
            self.containerView.dismissLoadingView()
            self.tripImageView.image = Constants.Images.defaultTrip
        }
        
        
        
        self.title = trip.name
    }
    
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        // Configure the cell...
        
        return cell
    }
    
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            
        }    
    }
    
    
    
    
    // MARK: - Navigation
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddExpenseSegue" {
            let destinationVC = segue.destination as? AddExpenseViewController
            
            destinationVC?.trip = trip
        }
        
        
    }
    
    
}
