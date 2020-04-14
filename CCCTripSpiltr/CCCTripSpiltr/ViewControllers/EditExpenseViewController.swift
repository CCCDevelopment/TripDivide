//
//  EditExpenseViewController.swift
//  CCCTripSpiltr
//
//  Created by Ryan Murphy on 4/14/20.
//  Copyright © 2020 Ryan Murphy. All rights reserved.
//

import UIKit
import Photos

class EditExpenseViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var trip: Trip?
    var expense: Expense?
    var imagePicker: ImagePicker!
    var image: UIImage!
    
    @IBOutlet weak var expenseNameTextField: UITextField!
    @IBOutlet weak var expenseCostTextField: UITextField!
    @IBOutlet weak var editExpenseSegmentedControll: UISegmentedControl!
    @IBOutlet weak var expenseParticipantCollectionView: UICollectionView!
    @IBOutlet weak var receiptImageView: UIImageView!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

      self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        configureUI()
        print(expense?.name)
    }
    
    
    func configureUI() {
        
        
        
        guard let expense = expense else { return }
        
        expenseCostTextField?.text = String(expense.cost)
        expenseNameTextField?.text = expense.name
        
        if let receipt = expense.receipt {
            UIImage().downloadImage(from: receipt) { (image) in
                DispatchQueue.main.async {
                    self.receiptImageView?.image = image
                }
            }
        }
        
    
        
    }
    
    
    
    
    @IBAction func actionButtonTapped(_ sender: Any) {
    }
    
    @IBAction func splitOptionsButtonTapped(_ sender: Any) {
    }
    
    @IBAction func addReceiptButtonTapped(_ sender: Any) {
       
           self.imagePicker.present(from: self.view)
           
       }

    @IBAction func saveButtonTapped(_ sender: Any) {
        
        guard let tripID = trip?.id else { return }
        view.showLoadingView()
        
        NetworkController.shared.uploadExpense(image: image, expense: expense!, tripID: tripID) { [weak self ](error) in
            guard let self = self else { return }
            self.view.dismissLoadingView()
            if let error = error {
                NSLog(error.rawValue)
            }
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}

extension EditExpenseViewController: UICollectionViewDelegate {

    
}

extension EditExpenseViewController: ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        self.image = image
       
        
    }
    
    
}
