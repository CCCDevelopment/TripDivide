//
//  ExpenseDetailViewController.swift
//  CCCTripSpiltr
//
//  Created by Ryan Murphy on 4/7/20.
//  Copyright © 2020 Ryan Murphy. All rights reserved.
//

import UIKit

class ExpenseDetailViewController: UIViewController, UICollectionViewDelegateFlowLayout {
    
    var expenseID: String?
    var expense: Expense?
    var paidBy: [String] = []
    var usedBy: [String] = []
    var trip: Trip?
    var dataSource: UICollectionViewDiffableDataSource<Section, String>!
    var otherDataSource: UICollectionViewDiffableDataSource<Section, String>!
    

    override func viewDidLoad() {
        super.viewDidLoad()
//        paidByCollectionView.delegate = self
//        usedByCollectionView.delegate = self
        configureUI()
        configureTapGesture()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
        getExpense()
        configurePaidByDataSource()
        configureUsedByDataSource()
        
    }
    
    enum Section {
        case main
    }
     
    @IBOutlet weak var paidByCollectionView: UICollectionView!
    @IBOutlet weak var usedByCollectionView: UICollectionView!
    @IBOutlet weak var receiptImageView: UIImageView!
    @IBOutlet weak var expenseCostLabel: UILabel!
    @IBOutlet weak var receiptLabel: UILabel!
    
    @objc func exitImageDetail() {
        dismiss(animated: true, completion: nil)
    }
    
    
    @objc func tapHandler() {
        
        let vc = UIViewController()
        let imageView = UIImageView(frame: vc.view.frame)
//        let nc = UINavigationController(rootViewController: vc)
//        let exitButton = UIBarButtonItem(barButtonSystemItem: .close, target: vc, action: #selector(self.exitImageDetail))
//
//        vc.navigationItem.rightBarButtonItem = exitButton
        
        
        imageView.contentMode = .scaleAspectFit
        imageView.image = receiptImageView.image

        vc.view.addSubview(imageView)
        //Change back to present NC if we still want to go the NavController way ...
        present(vc, animated: true, completion: nil)
         
    }
    
    func getExpense() {
        guard let expenseID = expenseID,
            let trip = trip else { return }
        
        NetworkController.shared.getExpense( expenseID: expenseID) { (expense, error) in
            if let error = error {
                NSLog(error.rawValue)
                return
            }
            self.title = expense?.name
            self.expense = expense
            self.getPaidByUsers()
            self.getUsedByUsers()
            
        }
    }
    
    func configureTapGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
        receiptImageView.isUserInteractionEnabled = true
        tapGestureRecognizer.numberOfTapsRequired = 1
        receiptImageView.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    func getPaidByUsers() {
            var paidByArray = [String]()
        for user in (expense?.paidBy.keys)! {
            paidByArray.append(user)
        }
        self.paidBy = paidByArray
        self.updatePaidData(on: self.paidBy)

  }
    
    func getUsedByUsers() {
        var usedByArray = [String]()
        for user in (expense?.usedBy.keys)! {
            usedByArray.append(user)
        }
        self.usedBy = usedByArray
        self.updateUsedData(on: self.usedBy)
    }
    
    func configurePaidByDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, String>(collectionView: paidByCollectionView, cellProvider: { (collectionView, indexpath, userID) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewDetailExpneseCell", for: indexpath) as! CollectionViewDetailExpneseCell
            
            cell.getUser(for: userID)
            return cell
            
        })
        
    }
    
    func configureUsedByDataSource() {
        otherDataSource = UICollectionViewDiffableDataSource<Section, String>(collectionView: usedByCollectionView, cellProvider: { (collectionView, indexpath, userID) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewDetailUsedByCell", for: indexpath) as! CollectionViewDetailUsedByCell
            
            cell.getUser(for: userID)
            return cell
            
        })
    }
    
    func updatePaidData(on friendIDs: [String]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.main])
        snapshot.appendItems(paidBy)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    func updateUsedData(on friendIDs: [String]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.main])
        snapshot.appendItems(usedBy)
        DispatchQueue.main.async {
            self.otherDataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    
    func configureUI() {
        guard let expense = expense else { return }
        let cost = String(expense.cost).currencyInputFormatting()
        self.expenseCostLabel?.text = cost
        self.title = "\(expense.name)"
        
        if let receipt = expense.receipt {
        UIImage().downloadImage(from: receipt) { (image) in
            DispatchQueue.main.async {
                self.receiptImageView.image = image
                
        
                }
            }
        }
    }
   
    @IBAction func editButtonTapped(_ sender: Any) {
    
        performSegue(withIdentifier: "EditExpenseSegue", sender: sender)
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditExpenseSegue" {
            let destinationVC = segue.destination as! EditExpenseViewController
            destinationVC.expense = self.expense
            destinationVC.trip = self.trip
        }
    }
    
//    func centerItemsInCollectionView(cellWidth: Double, numberOfItems: Double, spaceBetweenCell: Double, collectionView: UICollectionView) -> UIEdgeInsets {
//        let totalWidth = cellWidth * numberOfItems
//        let totalSpacingWidth = spaceBetweenCell * (numberOfItems - 1)
//        let leftInset = (collectionView.frame.width - CGFloat(totalWidth + totalSpacingWidth)) / 2
//        let rightInset = leftInset
//        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
//    }
    
}

extension ExpenseDetailViewController: UICollectionViewDelegate {
    
}




// Template for Removing from Diffable Data Source:
//extension ContactListViewController {
//    func remove(_ contact: Contact, animate: Bool = true) {
//        let snapshot = dataSource.snapshot()
//        snapshot.deleteItems([contact])
//        dataSource.apply(snapshot, animatingDifferences: animate)
//    }
//}
