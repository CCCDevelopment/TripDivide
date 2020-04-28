//
//  EditExpenseViewController.swift
//  CCCTripSpiltr
//
//  Created by Ryan Murphy on 4/14/20.
//  Copyright © 2020 Ryan Murphy. All rights reserved.
//

import UIKit
import Photos

class EditExpenseVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var trip: Trip?
    var expense: Expense?
    var oldTotal: Double?
    var imagePicker: ImagePicker!
    var image: UIImage! {
        didSet {
            DispatchQueue.main.async {
                self.receiptImageView.image = self.image
            }
        }
    }
    var dataSource: UICollectionViewDiffableDataSource<Section, String>?
    
    enum Section {
        case main
    }
    
    @IBOutlet weak var expenseNameTextField: UITextField!
    @IBOutlet weak var expenseCostTextField: UITextField!
    @IBOutlet weak var editExpenseSegmentedControll: UISegmentedControl!
    @IBOutlet weak var expenseParticipantCollectionView: UICollectionView!
    @IBOutlet weak var receiptImageView: UIImageView!
    
    @IBOutlet weak var deleteExpenseButton: UIButton!
    
    
    
    
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
        
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        if let formattedExpenseAmount = formatter.string(from: expense.cost as NSNumber) {
            self.expenseCostTextField.text = "\(formattedExpenseAmount)"
        }
        expenseNameTextField?.text = expense.name
        
        if let receipt = expense.receipt {
            UIImage().downloadImage(from: receipt) { (image) in
                self.image = image
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
        var vc = ExpenseSelectFriendsCollectionVC(selectType: .paidBy)
        
        switch editExpenseSegmentedControll.selectedSegmentIndex {
        case 0:
            vc = ExpenseSelectFriendsCollectionVC(selectType: .paidBy)
        case 1:
            vc = ExpenseSelectFriendsCollectionVC(selectType: .usedBy)
            
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
    
    func splitCost() {
        
        var paidByDict = [String: Double]()
        var usedByDict = [String: Double]()
        guard let usedByArray = expense?.usedBy.keys,
            let paidByArray = expense?.paidBy.keys,
            let expense = expense else { return }
        for userID in Array(paidByArray) {
                paidByDict[userID] = expense.cost / Double(paidByArray.count)
            }
        expense.paidBy = paidByDict
        
        

        for userID in Array(usedByArray) {
               usedByDict[userID] = expense.cost / Double(usedByArray.count)
            }
        expense.usedBy = usedByDict
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        splitCost()
        guard let tripID = trip?.id,
            let expense = expense
            else { return }
        
        NetworkController.shared.uploadExpense(image: image, expense: expense, oldTotal: oldTotal, tripID: tripID) {(error) in

            if let error = error {
                    NSLog(error.rawValue)
                }
            
                
                self.navigationController?.popViewController(animated: true)
        }
    }
        
    @IBAction func deleteButtonTapped(_ sender: Any) {
        
        guard let tripId = trip?.id,
            let expense = expense else { return }
        
        NetworkController.shared.deleteExpense(tripID: tripId, expense: expense, expenseID: expense.id, oldTotal: oldTotal) { (error) in
            if let error = error {
                NSLog(error.rawValue)
            }
        }
        
    }
    
    func updateExpense() {
        let name = expenseNameTextField.text ?? ""
        let cost = expenseCostTextField.text?.convertCurrencyToDouble() ?? 0.0

        expense!.name = name
        expense!.cost = cost
        
    }
    
    func updateData(on friendIDs: [String]) {
           var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
           snapshot.appendSections([.main])
           snapshot.appendItems(friendIDs)
           DispatchQueue.main.async {
               self.dataSource?.apply(snapshot, animatingDifferences: true)
           }
       }
}

extension EditExpenseVC: UICollectionViewDelegate {
    
}

extension EditExpenseVC: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        self.image = image
    }
    
}

extension EditExpenseVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        if textField == expenseCostTextField {
            textField.text = textField.text?.currencyInputFormatting()
        }
        updateExpense()
        return true
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == expenseCostTextField {
            textField.text = textField.text?.currencyInputFormatting()
        }
        updateExpense()
    }
}

