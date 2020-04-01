//
//  CCCTextView.swift
//  CCCTripSpiltr
//
//  Created by jonathan ferrer on 3/31/20.
//  Copyright © 2020 Ryan Murphy. All rights reserved.
//

import UIKit

class CCCTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.cornerRadius          = 10
        layer.borderWidth           = 1
        layer.borderColor           = UIColor.systemGray.cgColor
        
        textColor                   = .label
        tintColor                   = .label
        textAlignment               = .center
        font                        = UIFont.preferredFont(forTextStyle: .title3)
        adjustsFontSizeToFitWidth   = true
        minimumFontSize             = 12
        
        backgroundColor             = .tertiarySystemBackground
        autocorrectionType          = .no
        keyboardType                = .emailAddress
        returnKeyType               = .search
        clearButtonMode             = .whileEditing
        placeholder                 = "Enter an Email Address "
    }
}
