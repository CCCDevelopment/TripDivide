//
//  ActiveTripCell.swift
//  CCCTripSpiltr
//
//  Created by jonathan ferrer on 3/31/20.
//  Copyright © 2020 Ryan Murphy. All rights reserved.
//

import UIKit

class TripCell: UITableViewCell {


    @IBOutlet weak var tripImageView: UIImageView!
    @IBOutlet weak var tripNameLabel: UILabel!
    @IBOutlet weak var friendsCountLabel: UILabel!
    @IBOutlet weak var tripCostLabel: UILabel!
   
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 0.5
        contentView.layer.borderColor = UIColor.systemGray4.cgColor
        contentView.backgroundColor = UIColor.systemGray6
        
        tripImageView.layer.cornerRadius = 10
        tripImageView.layer.borderWidth = 0.5
        tripImageView.layer.borderColor = UIColor.tertiarySystemFill.cgColor
    }
    

    func set(tripID: String) {
        
        NetworkController.shared.getTrip(for: tripID) { [weak self] (trip, error) in
            guard let self = self else { return }
            
            if let error = error {
                NSLog(error.rawValue)
                return
            }
            
            guard let trip = trip else { return }
            
            self.tripNameLabel?.text = trip.name
            self.friendsCountLabel?.text = String(trip.users.count)
            self.tripCostLabel?.text = String(trip.totalCost)
            
            self.tripNameLabel.adjustsFontSizeToFitWidth = true
            self.tripNameLabel.minimumScaleFactor = 0.5
            
            if let image = trip.imageURL {
                UIImage().downloadImage(from: image) { (tripImage) in
                    guard let tripImage = tripImage else { return }
                    
                    DispatchQueue.main.async {
                        self.tripImageView.image = tripImage
                        
                    }
                }
                
            } else {
                self.tripImageView.image = Constants.Images.defaultTrip
            }
        }
        
    }
    
}
