//
//  CCCButton.swift
//  CCCTripSpiltr
//
//  Created by Ryan Murphy on 4/28/20.
//  Copyright © 2020 Ryan Murphy. All rights reserved.
//

import UIKit

class CCCButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        //custom code
        configure()
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(backgroundColor: UIColor, title: String) {
        super.init(frame: .zero)
        self.backgroundColor = backgroundColor
        self.setTitle(title, for: .normal)
        configure()
    }
    
    func set(backgroundColor: UIColor, title: String) {
        self.backgroundColor = backgroundColor
        setTitle(title, for: .normal)
    }
    
    private func configure() {
        
        layer.cornerRadius = 10
        setTitleColor(.white, for: .normal)
        // dynamic type ... Alows you to change the size of the text. Make sure that you use  ...
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        translatesAutoresizingMaskIntoConstraints = false
        
    }
    
}
