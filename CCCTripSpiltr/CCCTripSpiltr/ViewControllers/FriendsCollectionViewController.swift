//
//  FriendsCollectionViewController.swift
//  CCCTripSpiltr
//
//  Created by jonathan ferrer on 3/30/20.
//  Copyright © 2020 Ryan Murphy. All rights reserved.
//

import UIKit

class FriendsCollectionViewController: UIViewController {
    
    let collectionView = UICollectionView(frame: .zero)
    var user: User!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    
    
    private func configure() {
        
        NetworkController.shared.getCurrentUser { (user, error) in
            if let error = error {
                NSLog(error.rawValue)
            }
            
            guard let user = user else { return}
            self.user = user
        }
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    
    
}


extension FriendsCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return user.friends.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FriendCell.reuseID, for: indexPath) as? FriendCell else {
            return UICollectionViewCell() }
        let friendID = user.friends[indexPath.row]
        
        NetworkController.shared.getUser(for: friendID) { (user, error) in
            if let error = error {
                NSLog("\(error)")
            }
            
            guard let user = user else { return }
            cell.set(user: user)
        }
        
        return cell
    }
    
    
}




