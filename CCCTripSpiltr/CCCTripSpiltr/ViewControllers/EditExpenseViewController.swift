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
    var expenseID: String {
        getExpenseID(for: expense!)
    }
    var imagePicker: ImagePicker!
    var image: UIImage!
    var dataSource: UICollectionViewDiffableDataSource<Section, String>?
    
    enum Section {
        case main
    }
    
    @IBOutlet weak var expenseNameTextField: UITextField!
    @IBOutlet weak var expenseCostTextField: UITextField!
    @IBOutlet weak var editExpenseSegmentedControll: UISegmentedControl!
    @IBOutlet weak var expenseParticipantCollectionView: UICollectionView!
    @IBOutlet weak var receiptImageView: UIImageView!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        expenseParticipantCollectionView.delegate = self
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        configureUI()
        configureTextFields()
        
    }
   
    override func viewWillAppear(_ animated: Bool) {
        configureDataSource()
        super.viewWillAppear(animated)
    
        switch editExpenseSegmentedControll.selectedSegmentIndex {
        case 0:
            updateData(on: Array(expense!.paidBy.keys).sorted())
        case 1:
            updateData(on: Array(expense!.usedBy.keys).sorted())
        default:
            break
        }
    }
    
    
    
    
    
    
    //will not need this ... but I took the time to write it out so ...
    func getExpenseID(for expense: Expense) -> String {
        var expenseID: String = ""
        
        guard let expense = self.expense else { return "" }
        
        expenseID = expense.id
        
        return expenseID
        
    }
    
    func configureTextFields() {
        
        expenseNameTextField.delegate = self
        expenseCostTextField.delegate = self
        expenseCostTextField.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)
        
        
        
        
    }
    
    @objc func myTextFieldDidChange(_ textField: UITextField) {
        
        if let amountString = textField.text?.currencyInputFormatting() {
            textField.text = amountString
        }
    }
    
    func configureDataSource() {
           dataSource = UICollectionViewDiffableDataSource<Section, String>(collectionView: expenseParticipantCollectionView, cellProvider: { (collectionView, indexpath, userID) -> UICollectionViewCell? in
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExpenseAvatarCell", for: indexpath) as! ExpenseAvatarCell

               
               cell.getUser(for: userID)
               
                           

               return cell
         
           })
       
       }
    
    func configureUI() {
        guard let expense = expense else { return }
        
        expenseCostTextField?.text = "$" + String(expense.cost)
        expenseNameTextField?.text = expense.name
        
        if let receipt = expense.receipt {
            UIImage().downloadImage(from: receipt) { (image) in
                DispatchQueue.main.async {
                    self.receiptImageView?.image = image
                }
            }
        }
    }
    
    
    
    @IBAction func segmentedControllChanged(_ sender: Any) {
        
        switch editExpenseSegmentedControll.selectedSegmentIndex {
        case 0:
            updateData(on: Array(expense!.paidBy.keys).sorted())
        case 1:
            updateData(on: Array(expense!.usedBy.keys).sorted())
        default:
            break
        }
        
        
        
    }
    
    @IBAction func actionButtonTapped(_ sender: Any) {
        var vc = SelectFriendsForExpenseVC(selectType: .paidBy)
        
        switch editExpenseSegmentedControll.selectedSegmentIndex {
        case 0:
            vc = SelectFriendsForExpenseVC(selectType: .paidBy)
        case 1:
            vc = SelectFriendsForExpenseVC(selectType: .usedBy)
            
        default:
            break
        }
        
        vc.trip = trip
        vc.expense = expense
        navigationController?.pushViewController(vc, animated: true)
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
    
//    func updateExpense() {
//        let name = expenseNameTextField.text ?? ""
//
//
//        let cost = expenseNameTextField.text?.convertCurrencyToDouble() ?? 0.0
//
//        expense!.name = name
//        expense!.cost = cost
//    }
    
    func updateData(on friendIDs: [String]) {
           var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
           snapshot.appendSections([.main])
           snapshot.appendItems(friendIDs)
           DispatchQueue.main.async {
               self.dataSource?.apply(snapshot, animatingDifferences: true)
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

extension EditExpenseViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        if textField == expenseCostTextField {
            textField.text = textField.text?.currencyInputFormatting()
        }
//        updateExpense()
        return true
    }
    
   
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == expenseCostTextField {
            textField.text = textField.text?.currencyInputFormatting()
        }
//        updateExpense()
    }
}

