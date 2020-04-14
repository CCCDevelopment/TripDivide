//
//  EditExpenseViewController.swift
//  CCCTripSpiltr
//
//  Created by Ryan Murphy on 4/14/20.
//  Copyright © 2020 Ryan Murphy. All rights reserved.
//

import UIKit

class EditExpenseViewController: UIViewController {

    
    var expense: Expense?
    
    @IBOutlet weak var expenseNameTextField: UITextField!
    @IBOutlet weak var expenseCostTextField: UITextField!
    @IBOutlet weak var editExpenseSegmentedControll: UISegmentedControl!
    @IBOutlet weak var expenseParticipantCollectionView: UICollectionView!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    
    
    
    
    
    @IBAction func actionButtonTapped(_ sender: Any) {
    }
    
    @IBAction func splitOptionsButtonTapped(_ sender: Any) {
    }

    @IBAction func saveButtonTapped(_ sender: Any) {
    }
    
}
