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
     let cache = NetworkController.shared.cache
    @IBOutlet weak var avatarImageView: UIImageView!
    
    
    func getUser(for userID: String) {
        

    
    NetworkController.shared.getUser(for: userID) { (user, error) in
                    if let error = error {
                        NSLog(error.rawValue)
                        return
                    }
    
                    if let user = user {
    
                        self.updateImageView(user: user)
                    }
    
                }
    }
    
    func updateImageView(user: User) {
        
      
            let user = user
            
            if let imageURL = user.avatar {
                let cacheKey = NSString(string: imageURL)
               
                
                if let image = self.cache.object(forKey: cacheKey) {
                    self.avatarImageView?.image = image
                    
                    return
                }
                
                avatarImage = UIImage()
                self.avatarImage.downloadImage(from: imageURL) { [weak self] (image) in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        if let image = image {
                            self.cache.setObject(image, forKey: cacheKey)
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
