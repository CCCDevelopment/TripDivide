//
//  AddExpenseViewController.swift
//  CCCTripSpiltr
//
//  Created by Ryan Murphy on 4/2/20.
//  Copyright © 2020 Ryan Murphy. All rights reserved.
//

import UIKit

class AddExpenseViewController: UIViewController {
    
    var trip: Trip?
    var expense = Expense(name: "", cost: 0.0, paidBy: [:], usedBy: [:], recipet: nil)
    
    
    @IBOutlet weak var usedByCollectionView: UICollectionView!
    @IBOutlet weak var paidByCollectionView: UICollectionView!
    @IBOutlet weak var usedByButton: UIButton!
    @IBOutlet weak var paidByButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addRecieptImageView: UIImageView!
    @IBOutlet weak var costTextField: UITextField!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        costTextField.delegate = self
        paidByCollectionView.delegate = self
        paidByCollectionView.dataSource = self
        costTextField.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)
        
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
        NetworkController.shared.createExpense(expense: expense, tripID: tripID) { [weak self ](error) in
            guard let self = self else { return }
            self.view.dismissLoadingView()
            if let error = error {
                NSLog(error.rawValue)
            }
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func segmentedControlChanged(_ sender: Any) {
        
        paidByCollectionView.reloadData()
        
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

extension AddExpenseViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            return Array(expense.paidBy).count
        case 1:
            return Array(expense.usedBy).count
        default:
            return 0
            
        }
        
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExpenseAvatarCell", for: indexPath) as! ExpenseAvatarCell
        if collectionView == paidByCollectionView {
            
            
            var userIDArray = [String]()
            
            switch segmentedControl.selectedSegmentIndex {
            case 0:
                userIDArray = Array(expense.paidBy.keys).sorted()
            case 1:
                userIDArray = Array(expense.usedBy.keys).sorted()
            default:
                break
                
            }
            let userID = userIDArray[indexPath.item]
            
            NetworkController.shared.getUser(for: userID) { (user, error) in
                if let error = error {
                    NSLog(error.rawValue)
                    return
                }
                
                if let user = user {
                    
                    cell.updateImageView(user: user)
                }
                
            }
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
}
