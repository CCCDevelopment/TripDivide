//
//  TripEditVC.swift
//  CCCTripSpiltr
//
//  Created by Ryan Murphy on 4/28/20.
//  Copyright © 2020 Ryan Murphy. All rights reserved.
//

import UIKit

class TripEditVC: UIViewController, UICollectionViewDelegateFlowLayout {

    var tripID: String?
    var friends: [String] = []
    var trip: Trip?
    var dataSource: UICollectionViewDiffableDataSource<Section, String>!
    
    
    @IBOutlet weak var tripTitleTextField: UITextField!
    @IBOutlet weak var tripFriendsCollectionView: UICollectionView!
    
    
    enum Section {
        case main
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getTrip()
        configureFriendsDataSource()
        
    }
    
    
    
    
    @IBAction func saveButtonTapped(_ sender: Any) {
    }

    @IBAction func editFriendsButtonTapped(_ sender: Any) {
        let vc = TripEditFriendsCollectionVC()
       
        vc.trip = trip
        navigationController?.pushViewController(vc, animated: true)
        
        
        
           }
    
    @IBAction func tripCompletedButtonTapped(_ sender: Any) {
        
        guard let trip = trip else { return }
        
        let tripCompletedAlert = UIAlertController(title: "Complete Trip", message: "Pressing OK will mark this Trip as complete.", preferredStyle: UIAlertController.Style.alert)
        
        tripCompletedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
       
            trip.isComplete = !trip.isComplete
            print(trip.isComplete)
            
            // Have to make a network call to toggle trip.isComplete
            
            self.popBack(toControllerType: TripsTableVC.self)
        }))
        
        tripCompletedAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                self.dismiss(animated: true, completion: nil)
            }))
            
            present(tripCompletedAlert, animated: true, completion: nil)
        }
        
        
    
    @IBAction func deleteTripButtonTapped(_ sender: Any) {
    let areYouSureAlert = UIAlertController(title: "Delete Expense", message: "Deleting an expense cannot be undone.", preferredStyle: UIAlertController.Style.alert)
        
        areYouSureAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
        // TODO: Delet Trip and all Expenses associted with trip.
            
            self.popBack(toControllerType: TripsTableVC.self)
        }))
        
        areYouSureAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                self.dismiss(animated: true, completion: nil)
            }))
            
            present(areYouSureAlert, animated: true, completion: nil)
        }
        
    
    func popBack<T: UIViewController>(toControllerType: T.Type) {
        if var viewControllers: [UIViewController] = self.navigationController?.viewControllers {
            viewControllers = viewControllers.reversed()
            for currentViewController in viewControllers {
                if currentViewController .isKind(of: toControllerType) {
                    self.navigationController?.popToViewController(currentViewController, animated: true)
                    break
                }
            }
        }
    }
    
    
    func configureFriendsDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, String>(collectionView: tripFriendsCollectionView, cellProvider: { (collectionView, indexpath, userID) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TripEditCollectionViewCell", for: indexpath) as! TripEditCollectionViewCell
            
            cell.getUser(for: userID)
            return cell
            
        })
        
    }
    
    func updateFriendData(on friendIDs: [String]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.main])
        snapshot.appendItems(friends)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    func configureUI() {
        guard let trip = trip else { return }
        self.title = trip.name
        tripTitleTextField.text = trip.name
        
    }
    
    func getTripFriends() {
              var friendsArray = [String]()
        for user in (trip?.users)! {
              friendsArray.append(user)
          }
          self.friends = friendsArray
          self.updateFriendData(on: self.friends)

    }
    
    func getTrip() {
        
        guard let tripID = tripID else { return }
        NetworkController.shared.getTrip(for: tripID) { [weak self] (trip, error) in
            guard let self = self else { return }
            if let error = error {
                NSLog(error.rawValue)
            }
            guard let trip = trip else { return }
            self.trip = trip
            self.configureUI()
            self.getTripFriends()
        }
    }
}

extension TripEditVC: UICollectionViewDelegate {
    
}
