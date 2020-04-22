//
//  AddFriendCell.swift
//  CCCTripSpiltr
//
//  Created by Ryan Murphy on 4/21/20.
//  Copyright © 2020 Ryan Murphy. All rights reserved.
//

import UIKit


class AddFriendCell: UICollectionViewCell {
   
    static let reuseID = "AddFriendCell"
    let avatarImageView = CCCAvatarImageView(frame: .zero)
    let nameLabel = CCCTitleLabel(textAlignment: .center, fontSize: 14)
    var avatarImage: UIImage!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        avatarImageView.image = .add
        nameLabel.text = "Add Guest"
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.systemGray.cgColor
        self.layer.cornerRadius = 10
    }
    
}
