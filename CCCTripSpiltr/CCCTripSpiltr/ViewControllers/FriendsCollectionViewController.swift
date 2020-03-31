//
//  FriendsCollectionViewController.swift
//  CCCTripSpiltr
//
//  Created by jonathan ferrer on 3/30/20.
//  Copyright © 2020 Ryan Murphy. All rights reserved.
//

import UIKit

class FriendsCollectionViewController: UIViewController {
    
    var collectionView: UICollectionView!
    var friends = [String]()
    
    
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
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: Utilities.createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FriendCell.self, forCellWithReuseIdentifier: FriendCell.reuseID)
    }
    
    @objc func addButtonTapped() {
        present(AddFriendVC(), animated: true, completion: nil)
        
    }
    
}


extension FriendsCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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
    
    
}




