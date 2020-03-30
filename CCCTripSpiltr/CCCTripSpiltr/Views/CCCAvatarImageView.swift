//
//  CCCAvatarImageView.swift
//  CCCTripSpiltr
//
//  Created by jonathan ferrer on 3/30/20.
//  Copyright © 2020 Ryan Murphy. All rights reserved.
//

import UIKit

class CCCAvatarImageView: UIImageView {
    
    let placeholderImage = Constants.Images.placeholderImage
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        layer.cornerRadius = 10
        clipsToBounds = true
        image = placeholderImage
        translatesAutoresizingMaskIntoConstraints = false
    }
    

}
