//
//  DetailExpenceTableViewCell.swift
//  CCCTripSpiltr
//
//  Created by Ryan Murphy on 4/7/20.
//  Copyright © 2020 Ryan Murphy. All rights reserved.
//

import UIKit

class ExpenseDetailTableViewCell: UITableViewCell {


    var tripID: String?  {
           didSet{
               configureViews()
           }
       }
    var expenseID: String?
    
    @IBOutlet weak var experienceNameLabel: UILabel!
    @IBOutlet weak var experienceCostLabel: UILabel!
    @IBOutlet weak var recipetImageView: UIImageView!
    
    func configureViews() {
        guard let tripID = tripID,
            let expenseID = expenseID else { return }
        NetworkController.shared.getExpense( expenseID: expenseID) { [weak self] (expense, error) in
            guard let self = self else { return }
            
            if let error = error {
                NSLog(error.rawValue)
            }
            guard let expense = expense else { return }
            self.experienceNameLabel.text = expense.name
            let formatter = NumberFormatter()
            formatter.locale = Locale.current
            formatter.numberStyle = .currency
            if let formattedExpenseAmount = formatter.string(from: expense.cost as NSNumber) {
                self.experienceCostLabel.text = "\(formattedExpenseAmount)"
            }
            
        }
        
       
    }
    
    
    
   override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 0.5
        contentView.layer.borderColor = UIColor.systemGray4.cgColor
        contentView.backgroundColor = UIColor.systemGray6
    

    }
   
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    
    
}
