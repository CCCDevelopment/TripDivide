//
//  SelectFriendsCollectionViewController.swift
//  CCCTripSpiltr
//
//  Created by jonathan ferrer on 4/1/20.
//  Copyright © 2020 Ryan Murphy. All rights reserved.
//

import UIKit
import Firebase

class SelectFriendsCollectionViewController: UIViewController {
    
    
    
    var collectionView: UICollectionView!
    var friends = [String]()
    var selectedFriends = [String]()
    var tripName: String?
    var image: UIImage?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        configureCollectionView()
        configureViewController()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFriends()
    }
    
    func getFriends() {
        
        NetworkController.shared.getCurrentUser { [weak self] (user, error) in
            guard let self = self else { return }
            if let error = error {
                NSLog(error.rawValue)
            }
            guard let user = user else { return }
            
            self.friends = user.friends
            
            
            self.collectionView.reloadData()
        }
    }
    
    
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let createButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(createButtonPressed))
        navigationItem.rightBarButtonItem = createButton
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: Utilities.createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FriendCell.self, forCellWithReuseIdentifier: FriendCell.reuseID)
        collectionView.allowsMultipleSelection = true
        
    }
    
    @objc func createButtonPressed() {
        guard let tripName = tripName else { return}
        view.showLoadingView()
        NetworkController.shared.uploadTrip(image: image, name: tripName, friendIds: selectedFriends) { [weak self](error) in
            guard let self = self else { return }
            self.view.dismissLoadingView()
            if let error = error {
                NSLog(error.rawValue)
                return
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
}


extension SelectFriendsCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return friends.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FriendCell.reuseID, for: indexPath) as? FriendCell else {
            return UICollectionViewCell() }
        let friendID = friends[indexPath.row]

        cell.set(userID: friendID)
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let userID = friends[indexPath.item]
        let cell = collectionView.cellForItem(at: indexPath)
        if selectedFriends.contains(userID) {
            return
        }
        cell?.contentView.backgroundColor = .systemTeal
        selectedFriends.append(userID)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let userID = friends[indexPath.item]
        let cell = collectionView.cellForItem(at: indexPath)

        if selectedFriends.contains(userID) {
            selectedFriends.remove(at: selectedFriends.firstIndex(of: userID)!)
        }
        cell?.contentView.backgroundColor = nil
        

    }
}


