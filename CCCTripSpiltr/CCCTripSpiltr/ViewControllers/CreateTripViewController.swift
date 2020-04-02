//
//  CreateTripViewController.swift
//  CCCTripSpiltr
//
//  Created by jonathan ferrer on 4/1/20.
//  Copyright © 2020 Ryan Murphy. All rights reserved.
//

import UIKit
import Photos

class CreateTripViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imagePicker: ImagePicker!
    var image: UIImage!
    
    @IBOutlet weak var tripNameTextField: UITextField!
    @IBOutlet weak var tripImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
    }
    
    
    
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        guard let tripName = tripNameTextField.text,
            !tripName.isEmpty else { return }
        let selectFriendsVC = SelectFriendsCollectionViewController()
        selectFriendsVC.tripName = tripName
        
        if let image = image {
            selectFriendsVC.image = image
        } else {
            let image = Constants.Images.defaultTrip
            selectFriendsVC.image = image
        }
        
        navigationController?.pushViewController(selectFriendsVC, animated: true)
        
        
    }
    
    
    @IBAction func addPhotoPressed(_ sender: Any) {
        
        self.imagePicker.present(from: self.view)
        
    }
}
    
extension CreateTripViewController: ImagePickerDelegate {

    func didSelect(image: UIImage?) {
        self.image = image
        self.tripImageView.image = image
    }
}
