//
//  FriendsCollectionViewController.swift
//  CCCTripSpiltr
//
//  Created by jonathan ferrer on 3/30/20.
//  Copyright © 2020 Ryan Murphy. All rights reserved.
//

import UIKit

class FriendsCollectionVC: UIViewController {
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, String>!

    
    
    enum Section {
        case main
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        configureCollectionView()
        configureViewController()
        collectionView.delegate = self
//        collectionView.dataSource =
        configureDataSource()
        getFriends()
        
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

            
            self.updateData(on: user.friends)
        }
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, String>(collectionView: collectionView, cellProvider: { (collectionView, indexpath, userID) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendCell", for: indexpath) as! FriendCell
            cell.set(userID: userID)
            return cell
      
        })
    }
    
    
    func updateData(on friendIDs: [String]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.main])
        snapshot.appendItems(friendIDs)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
  
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        title = "Friends"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
        
       
        
    }
    
    @IBAction func editUserbuttonPressed(_ sender: Any) {
        
        let vc = UserInfoVC()
        present(vc, animated: true, completion: nil)
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: Utilities.createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FriendCell.self, forCellWithReuseIdentifier: FriendCell.reuseID)
    }
    
    @objc func addButtonTapped() {
        let vc = AddFriendVC()
        vc.delegate = self
        
        present(vc, animated: true, completion: nil)
        
    }
    
}


extension FriendsCollectionVC: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return friends.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FriendCell.reuseID, for: indexPath) as? FriendCell else {
//            return UICollectionViewCell() }
//        let sortedFriends = friends.sorted()
//        let friendID = sortedFriends[indexPath.row]
//
//        cell.set(userID: friendID)
//
//        return cell
//    }
}

extension FriendsCollectionVC: AddFriendVCDelegate {
    func friendAdded() {
        getFriends()
    }
}



