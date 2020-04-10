//
//  ExpenseAvatarCell.swift
//  CCCTripSpiltr
//
//  Created by jonathan ferrer on 4/3/20.
//  Copyright © 2020 Ryan Murphy. All rights reserved.
//

import UIKit

class ExpenseAvatarCell: UICollectionViewCell {
    
    static let reuseID = "ExpenseAvatarCell"
    var avatarImage: UIImage!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    func updateImageView(user: User) {
        
      
            let user = user
            
            if let imageURL = user.avatar {
                
                self.avatarImage = UIImage()
                self.avatarImage.downloadImage(from: imageURL) { [weak self] (image) in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        if let image = image {
                            
                            self.avatarImageView?.image = image
                        }
                    }
                }
            } else {
                
                guard let string = user.fullName.first else { return }
                print(string)
                
                
                self.avatarImageView?.image = UIImage(systemName: "\(string.lowercased()).circle")
            }
            
            
        }
    
    
}
