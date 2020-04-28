//
//  ActiveTripCell.swift
//  CCCTripSpiltr
//
//  Created by jonathan ferrer on 3/31/20.
//  Copyright © 2020 Ryan Murphy. All rights reserved.
//

import UIKit

class TripCell: UITableViewCell {

 let cache = NetworkController.shared.cache
    
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
            let formatter = NumberFormatter()
            formatter.locale = Locale.current // Change this to another locale if you want to force a specific locale, otherwise this is redundant as the current locale is the default already
            formatter.numberStyle = .currency
            if let formattedTripAmount = formatter.string(from: trip.totalCost as NSNumber) {
                self.tripCostLabel.text = "\(formattedTripAmount)"
            }
            
            self.tripNameLabel.adjustsFontSizeToFitWidth = true
            self.tripNameLabel.minimumScaleFactor = 0.5
            
            if let image = trip.imageURL {
                let cacheKey = NSString(string: tripID)
                
                if let image = self.cache.object(forKey: cacheKey) {
                    self.tripImageView.image = image
                    return
                }
                
                UIImage().downloadImage(from: image) { (tripImage) in
                    guard let tripImage = tripImage else { return }
                    self.cache.setObject(tripImage, forKey: cacheKey)
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
