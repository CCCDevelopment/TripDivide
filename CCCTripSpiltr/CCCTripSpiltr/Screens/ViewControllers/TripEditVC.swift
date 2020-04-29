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
    }
    @IBAction func tripCompletedButtonTapped(_ sender: Any) {
    }
    @IBAction func deleteTripButtonTapped(_ sender: Any) {
    }
    
    // Need to set up a new cell for Collection view!
    func configureFriendsDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, String>(collectionView: tripFriendsCollectionView, cellProvider: { (collectionView, indexpath, userID) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewDetailExpneseCell", for: indexpath) as! ExpenseDetailPaidByCollectionViewCell
            
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
