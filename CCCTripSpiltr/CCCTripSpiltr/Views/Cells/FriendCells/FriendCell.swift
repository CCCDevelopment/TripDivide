//
//  FriendCell.swift
//  CCCTripSpiltr
//
//  Created by jonathan ferrer on 3/30/20.
//  Copyright © 2020 Ryan Murphy. All rights reserved.
//

import UIKit

class FriendCell: UICollectionViewCell {
    
    static let reuseID = "FriendCell"
    let cache = NetworkController.shared.cache
    let avatarImageView = CCCAvatarImageView(frame: .zero)
    let nameLabel = CCCTitleLabel(textAlignment: .center, fontSize: 14)
    var userID: String?
    var avatarImage: UIImage!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set(userID: String) {
        self.userID = userID
        
        NetworkController.shared.getUser(for: userID) { [weak self] (user, error) in
            guard let self = self else { return }
            if let error = error {
                NSLog("\(error)")
            }
            
            guard let user = user else { return }
            self.nameLabel.text = user.fullName
            
            if let avatarURL = user.avatar {
                self.updateImageView(imageURL: avatarURL)
            }
            
        }
        
    }
    
    
    func updateImageView(imageURL: String) {
        avatarImage = UIImage()
        let cacheKey = NSString(string: imageURL)
        
        if let image = self.cache.object(forKey: cacheKey) {
            self.avatarImageView.image = image
            return
        }
                avatarImage.downloadImage(from: imageURL) { [weak self] (image) in
                    guard let self = self else { return }
                        if let image = image {
                            DispatchQueue.main.async {
                            self.cache.setObject(image, forKey: cacheKey)
                            self.avatarImageView.image = image
                    }
               
                    } else {
                            guard let letter = self.nameLabel.text?.first else { return }
                        self.avatarImageView.image = UIImage(systemName: String(letter))
                    }
            }
        }
    
    
    
    
    private func configure() {
        addSubviews(avatarImageView, nameLabel)
        contentView.layer.cornerRadius = 10
        
        let padding: CGFloat = 8
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            avatarImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            nameLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
}
