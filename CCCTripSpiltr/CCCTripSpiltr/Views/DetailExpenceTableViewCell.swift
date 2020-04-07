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
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
