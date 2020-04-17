//
//  AddExpenseViewController.swift
//  CCCTripSpiltr
//
//  Created by Ryan Murphy on 4/2/20.
//  Copyright © 2020 Ryan Murphy. All rights reserved.
//

import UIKit
import Photos

class AddExpenseViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var trip: Trip?
    var expense = Expense(name: "", receipt: nil, cost: 0.0, paidBy: [:], usedBy: [:])
    var imagePicker: ImagePicker!
    var image: UIImage!
    

    @IBOutlet weak var paidByCollectionView: UICollectionView!
    @IBOutlet weak var paidByButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var costTextField: UITextField!
    @IBOutlet weak var receiptImageView: UIImageView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    var dataSource: UICollectionViewDiffableDataSource<Section, String>!

    
    
    enum Section {
        case main
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        costTextField.delegate = self
        paidByCollectionView.delegate = self
        configureDataSource()
        costTextField.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            updateData(on: Array(expense.paidBy.keys).sorted())
        case 1:
            updateData(on: Array(expense.usedBy.keys).sorted())
        default:
            break
        }
    }
    
    
    @objc func myTextFieldDidChange(_ textField: UITextField) {
        
        if let amountString = textField.text?.currencyInputFormatting() {
            textField.text = amountString

        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        paidByCollectionView.reloadData()
    }
    
    
    func updateExpense() {
        let name = nameTextField.text ?? ""
        
        
        let cost = costTextField.text?.convertCurrencyToDouble() ?? 0.0
        
        expense.name = name
        expense.cost = cost
    }
    @IBAction func saveButtonPressed(_ sender: Any) {
        guard let tripID = trip?.id else { return }
        view.showLoadingView()
        
        NetworkController.shared.uploadExpense(image: image, expense: expense, tripID: tripID) { [weak self ](error) in
            guard let self = self else { return }
            self.view.dismissLoadingView()
            if let error = error {
                NSLog(error.rawValue)
            }
            
            self.navigationController?.popViewController(animated: true)
        }
    
    }
    
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            updateData(on: Array(expense.paidBy.keys).sorted())
        case 1:
            updateData(on: Array(expense.usedBy.keys).sorted())
        default:
            break
        }
        
        
        
    }
    
    
    
    @IBAction func addReceiptButtonTapped(_ sender: Any) {
    
        self.imagePicker.present(from: self.view)
        
    }
    
    
    
    @IBAction func splitOptionsButtonTapped(_ sender: Any) {
        
    }
    @IBAction func paidByButtonTapped(_ sender: Any) {
        
        var vc = SelectFriendsForExpenseVC(selectType: .paidBy)
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            vc = SelectFriendsForExpenseVC(selectType: .paidBy)
        case 1:
            vc = SelectFriendsForExpenseVC(selectType: .usedBy)
            
        default:
            break
        }
        
        vc.trip = trip
        vc.expense = expense
        navigationController?.pushViewController(vc, animated: true)
        
    }
    @IBAction func usedByButtonTapped(_ sender: Any) {
        let vc = SelectFriendsForExpenseVC(selectType: .usedBy)
        vc.trip = trip
        vc.expense = expense
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, String>(collectionView: paidByCollectionView, cellProvider: { (collectionView, indexpath, userID) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExpenseAvatarCell", for: indexpath) as! ExpenseAvatarCell

            
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

    
    
    
}


extension AddExpenseViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        if textField == costTextField {
            textField.text = textField.text?.currencyInputFormatting()
        }
        updateExpense()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == costTextField {
            textField.text = textField.text?.currencyInputFormatting()
        }
        updateExpense()
    }
}

extension String {
    
    // formatting text for currency textField
    func currencyInputFormatting() -> String {
        
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        var amountWithPrefix = self
        
        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")
        
        let double = (amountWithPrefix as NSString).doubleValue
        
        number = NSNumber(value: (double / 100))
        guard number != 0 as NSNumber else {
            return ""
        }
        
        return formatter.string(from: number)!
    }
    
    func convertCurrencyToDouble() -> Double? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale.current
        
        return numberFormatter.number(from: self)?.doubleValue
    }
}

extension AddExpenseViewController: UICollectionViewDelegate {

    
}

extension AddExpenseViewController: ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        self.image = image
        self.receiptImageView.image = image
    }
    
    
}
