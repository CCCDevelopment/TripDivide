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
    
    
    @IBOutlet weak var usedByCollectionView: UserAvatarCollectionView!
    @IBOutlet weak var paidByCollectionView: UserAvatarCollectionView!
    @IBOutlet weak var usedByButton: UIButton!
    @IBOutlet weak var paidByButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addRecieptImageView: UIImageView!
    @IBOutlet weak var costTextField: UITextField!
    

    override func viewDidLoad() {
         super.viewDidLoad()
        nameTextField.delegate = self
        costTextField.delegate = self
    
    
    costTextField.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)
           }

           @objc func myTextFieldDidChange(_ textField: UITextField) {

               if let amountString = textField.text?.currencyInputFormatting() {
                   textField.text = amountString
               }
           }

    
    override func viewWillAppear(_ animated: Bool) {
        print("Paid by \(expense.paidBy.count) people")
        print("Used by \(expense.usedBy.count) people")
        
        for this in expense.paidBy {
            print("\(this.key) pays \(this.value)")
        }
        
        for this in expense.usedBy {
            print("\(this.key) used \(this.value)")
        }
    }
    

    func updateExpense() {
        let name = nameTextField.text ?? ""
        
        
        let cost = costTextField.text?.convertCurrencyToDouble() ?? 0.0
        
        expense.name = name
        expense.cost = cost
    }
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        
    }
    

    @IBAction func splitOptionsButtonTapped(_ sender: Any) {
        
    }
    @IBAction func paidByButtonTapped(_ sender: Any) {
        
        let vc = SelectFriendsForExpenseVC(selectType: .paidBy)
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
        updateExpense()
        
        textField.resignFirstResponder()
        if textField == costTextField {
            textField.text = textField.text?.currencyInputFormatting()
        }
        return true
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
