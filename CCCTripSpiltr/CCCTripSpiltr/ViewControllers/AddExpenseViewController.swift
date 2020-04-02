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
         
         configure()
        nameTextField.delegate = self
        costTextField.delegate = self
     }
    
    override func viewWillAppear(_ animated: Bool) {
        print("Paid by \(expense.paidBy.count) people")
        print("Used by \(expense.usedBy.count) people")
    }
    
    func configure() {
   
    }
    

    func updateExpense() {
        let name = nameTextField.text ?? ""
        let cost = Double(costTextField.text ?? "0.0") ?? 0.0
        
        expense.name = name
        expense.cost = cost
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
        return true
    }
}
