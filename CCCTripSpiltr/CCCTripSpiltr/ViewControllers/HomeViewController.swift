//
//  HomeViewController.swift
//  CustomLoginDemo
//
//  Created by Christopher Ching on 2019-07-22.
//  Copyright © 2019 Christopher Ching. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let user = Auth.auth().currentUser?.uid else { return }
        print(user)
    }
    
    @IBAction func createTripTapped(_ sender: UIButton) {
        NetworkController.shared.createTrip(with: "Italy") { (error) in
            if let error = error {
                NSLog("\(error.rawValue)")
            }
           
        }
    }
    
}
