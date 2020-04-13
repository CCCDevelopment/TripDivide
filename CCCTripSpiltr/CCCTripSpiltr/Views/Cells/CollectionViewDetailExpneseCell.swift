//
//  CollectionViewDetailExpneseCell.swift
//  CCCTripSpiltr
//
//  Created by Ryan Murphy on 4/13/20.
//  Copyright © 2020 Ryan Murphy. All rights reserved.
//

import UIKit

class CollectionViewDetailExpneseCell: UICollectionViewCell {
    
    let cache = NetworkController.shared.cache
    var avatarImage: UIImage!

    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
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
                self.userImageView?.image = image
                self.userNameLabel?.text = user.fullName
             
                
                
                return
            }
            
            avatarImage = UIImage()
            self.avatarImage.downloadImage(from: imageURL) { [weak self] (image) in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    if let image = image {
                        self.cache.setObject(image, forKey: cacheKey)
                        self.userImageView?.image = image
                        self.userNameLabel?.text = user.fullName
                          
                    }
                }
            }
        } else {
            
            guard let string = user.fullName.first else { return }
            print(string)
            
            
            self.userImageView?.image = UIImage(systemName: "\(string.lowercased()).circle")
            self.userNameLabel?.text = user.fullName
              
        }
        
        
    }
    
    
}
