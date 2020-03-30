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
    var user: User!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        
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
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createThreeColumnFlowLayout(in: view))
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FriendCell.self, forCellWithReuseIdentifier: FriendCell.reuseID)
    }
    
    func createThreeColumnFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {
        let width = view.bounds.width
        let padding: CGFloat = 12
        let minimumItemSpacing: CGFloat = 10
        let availableWidth = width - (padding * 2) - (minimumItemSpacing * 2)
        let itemWidth = availableWidth / 3
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 40)
        
        return flowLayout
    }
    
}


extension FriendsCollectionViewController: UICollectionViewDelegate {
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




