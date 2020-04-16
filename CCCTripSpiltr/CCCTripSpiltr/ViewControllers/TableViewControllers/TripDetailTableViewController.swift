//
//  TripDetailTableViewController.swift
//  CCCTripSpiltr
//
//  Created by jonathan ferrer on 4/1/20.
//  Copyright © 2020 Ryan Murphy. All rights reserved.
//

import UIKit

class TripDetailTableViewController: UITableViewController {
    
    
    var tripID: String? {
        didSet {
            getTrip()
        }
    }
    var trip: Trip? {
        didSet {
            userAvatarCollectionView.reloadData()
        }
        
        
    }
    var tripTotal: Double! {
            getTripTotal()
    }
    
    
    
    @IBOutlet weak var containerView: UIView!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userAvatarCollectionView.delegate = self
        userAvatarCollectionView.dataSource = self

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userAvatarCollectionView.register(ExpenseAvatarCell.self, forCellWithReuseIdentifier: "ExpenseAvatarCell")
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
    
    func getTripTotal() -> Double {
        guard let trip = trip else { return 0.0 }
        var total: Double = 0.0
        if trip.expenses.count == 0 { return total } else {
        for expense in trip.expenses {
            
            total += expense.cost
            }
        return total
        }
    }
    
    func configureViews () {
        guard let trip = trip else { return }
        
        if let image = trip.imageURL {
            UIImage().downloadImage(from: image) { (tripImage) in

                guard let tripImage = tripImage
                    else { return }
                
                DispatchQueue.main.async {
                    self.tripImageView.image = tripImage
                }
            }
        } else {
            self.tripImageView.image = Constants.Images.defaultTrip
        }

        
        
        if tripTotal == 0.0 {
            costLabel.text = "$0.00"
        } else {
        costLabel.text = String(tripTotal).currencyInputFormatting()
        }
        
        
        self.title = trip.name
        tableView.reloadData()
        
    }
    
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let trip = trip else { return 1 }
        return trip.expenses.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenseCell", for: indexPath) as! DetailExpenseTableViewCell
        
        guard let trip = trip else {
            return DetailExpenseTableViewCell()
        }
        
        let tripExpense = trip.expenses[indexPath.row]
        cell.experienceNameLabel.text = tripExpense.name
        print(tripExpense.cost)
        cell.experienceCostLabel.text = String(tripExpense.cost).currencyInputFormatting()
        
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    
    
    // MARK: - Navigation
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddExpenseSegue" {
            let destinationVC = segue.destination as? AddExpenseViewController
            destinationVC?.trip = trip
        } else if segue.identifier == "ViewExpenseDetailSegue" {
            let destinationVC = segue.destination as? ExpenseDetailViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC?.expense = trip?.expenses[indexPath.row]
            }
            
            }
        }
        
        
    
    
    
}

extension TripDetailTableViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        trip?.users.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExpenseAvatarCell", for: indexPath) as! ExpenseAvatarCell
        
        guard let trip = trip else {
            print("NotGettingATrip")
            return cell
        }
        
        //How can I get userID's from here?
        
        let userID = trip.users[indexPath.item]
        
        NetworkController.shared.getUser(for: userID) { (user, error) in
            if let error = error {
                NSLog(error.rawValue)
                return
            }
            
            if let user = user {
                
                cell.updateImageView(user: user)
            }
            
        }
        return cell
    }
}
