//
//  TripUserAvatarCell.swift
//  CCCTripSpiltr
//
//  Created by Ryan Murphy on 4/9/20.
//  Copyright © 2020 Ryan Murphy. All rights reserved.
//

import UIKit

class TripUserAvatarCell: UICollectionViewCell {
    
    var avatarImage: UIImage!

     
    @IBOutlet weak var avatarImagetwoView: UIImageView!
    
    
    override func layoutSubviews() {
        
        avatarImagetwoView.layer.cornerRadius = 10
    }
    
    
    func updateImageView(user: User) {
      
    
          let user = user
          
          if let imageURL = user.avatar {
              
              self.avatarImage = UIImage()
              self.avatarImage.downloadImage(from: imageURL) { [weak self] (image) in
                  guard let self = self else { return }
                  DispatchQueue.main.async {
                      if let image = image {
                          
                          self.avatarImagetwoView?.image = image
                      }
                  }
              }
          } else {
              
              guard let string = user.fullName.first else { return }
              print(string)
              
              
              self.avatarImagetwoView?.image = UIImage(systemName: "\(string.lowercased()).circle")
          }
          
          
      }
}
