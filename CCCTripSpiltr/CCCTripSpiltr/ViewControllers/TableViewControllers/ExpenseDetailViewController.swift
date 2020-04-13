//
//  ExpenseDetailViewController.swift
//  CCCTripSpiltr
//
//  Created by Ryan Murphy on 4/7/20.
//  Copyright © 2020 Ryan Murphy. All rights reserved.
//

import UIKit

class ExpenseDetailViewController: UIViewController {
    
    var expense: Expense?
    var paidBy: [String] = []
    
    var dataSource: UICollectionViewDiffableDataSource<Section, String>!

    override func viewDidLoad() {
        super.viewDidLoad()
        paidByCollectionView.delegate = self
        getPaidByUsers()
        configurePaidByDataSource()
     
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateData(on: paidBy)
    }
    
    enum Section {
        case main
    }
    
    @IBOutlet weak var paidByCollectionView: UICollectionView!
    @IBOutlet weak var usedByCollectionView: UICollectionView!
    @IBOutlet weak var receiptImageView: UIImageView!
    @IBOutlet weak var expenseCostLabel: UILabel!
    @IBOutlet weak var receiptLabel: UILabel!
    
    func getPaidByUsers() {
        
        for user in (expense?.paidBy.keys)! {
            paidBy.append(user)
        }
        
        
    }
    
    func configurePaidByDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, String>(collectionView: paidByCollectionView, cellProvider: { (collectionView, indexpath, userID) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewDetailExpneseCell", for: indexpath) as! CollectionViewDetailExpneseCell

            
            cell.getUser(for: userID)
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
    
//    func configureUsedByDataSource() {
//          dataSource = UICollectionViewDiffableDataSource<Section, String>(collectionView: usedByCollectionView, cellProvider: { (collectionView, indexpath, userID) -> UICollectionViewCell? in
//              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewDetailExpneseCell", for: indexpath) as! CollectionViewDetailExpneseCell
//
//
//              cell.getUser(for: userID)
//
//
//
//              return cell
//
//          })
//
//      }
    
    
}

extension ExpenseDetailViewController: UICollectionViewDelegate {
    
}
