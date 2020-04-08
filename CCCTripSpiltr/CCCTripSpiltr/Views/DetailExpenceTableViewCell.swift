//
//  DetailExpenceTableViewCell.swift
//  CCCTripSpiltr
//
//  Created by Ryan Murphy on 4/7/20.
//  Copyright © 2020 Ryan Murphy. All rights reserved.
//

import UIKit

class DetailExpenceTableViewCell: UITableViewCell {


   
    
    @IBOutlet weak var experienceNameLabel: UILabel!
    @IBOutlet weak var experienceCostLabel: UILabel!
    @IBOutlet weak var recipetImageView: UIImageView!
    
    
    
   override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 0.5
        contentView.layer.borderColor = UIColor.systemGray4.cgColor
        contentView.backgroundColor = UIColor.systemGray2
    
//       recipetImageView.layer.cornerRadius = 10
//       recipetImageView.layer.borderWidth = 0.5
//       recipetImageView.layer.borderColor = UIColor.tertiarySystemFill.cgColor
    }
   
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    
    
}
