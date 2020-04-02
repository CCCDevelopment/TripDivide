//
//  CCCAlertVC.swift
//  CCCTripSpiltr
//
//  Created by Ryan Murphy on 3/31/20.
//  Copyright © 2020 Ryan Murphy. All rights reserved.
//

import UIKit

protocol AddFriendVCDelegate {
    func friendAdded()
}

class AddFriendVC: UIViewController {
    
    let containerView = UIView()
    let titleLabel = CCCTitleLabel(textAlignment: .center, fontSize: 20)
    let emailTextField = CCCTextField()
    let addActionButton = UIButton()
    let closeActionButton = UIButton()
    let avatarImageView = CCCAvatarImageView(frame: .zero)
    let nameLabel = UILabel()
    var searchedUser: User?
    var alertTitle: String = "Search For Friends"
    var message: String = " Enter Email Address"
    var buttonTitle: String = "Close"
    var addButtonTitle: String = "Add"
    var delegate: AddFriendVCDelegate?
    
    let padding: CGFloat = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        emailTextField.delegate = self
        configureContainerView()
        configureTitleLabel()
        configureActionButtons()
        configureEmailTextField()
        configureSearchResultViews()
    }
    
    func configureContainerView() {
        view.addSubview(containerView)
        
        containerView.backgroundColor = .systemBackground
        containerView.layer.cornerRadius = 16
        containerView.layer.borderWidth = 0.5
        containerView.layer.borderColor = UIColor.systemGray.cgColor
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 280),
            containerView.heightAnchor.constraint(equalToConstant: 375)
        ])
        
    }
    
    func configureTitleLabel() {
        containerView.addSubview(titleLabel)
        titleLabel.text = alertTitle
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 28)
        ])
    }
    
    func configureActionButtons() {
        Utilities.styleFilledButton(closeActionButton, fillColor: .systemRed)
        closeActionButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(closeActionButton)
        closeActionButton.setTitle(buttonTitle, for: .normal)
        closeActionButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        
        Utilities.styleFilledButton(addActionButton, fillColor: .systemGreen)
        addActionButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(addActionButton)
        addActionButton.setTitle(addButtonTitle, for: .normal)
        addActionButton.addTarget(self, action: #selector(addAction), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            closeActionButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding),
            closeActionButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            closeActionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            closeActionButton.heightAnchor.constraint(equalToConstant: 44),
            
            addActionButton.bottomAnchor.constraint(equalTo: closeActionButton.topAnchor, constant: -8),
            addActionButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            addActionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            addActionButton.heightAnchor.constraint(equalToConstant: 44)
            
        ])
    }
    
    func configureEmailTextField() {
        
        containerView.addSubview(emailTextField)
        
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: padding),
            emailTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            emailTextField.heightAnchor.constraint(equalToConstant: 35),
            emailTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            
        ])
    }
    func configureSearchResultViews() {
        containerView.addSubview(avatarImageView)
        nameLabel.text = "asdf"
        containerView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textAlignment = .center
        NSLayoutConstraint.activate([
            
            nameLabel.bottomAnchor.constraint(equalTo: addActionButton.topAnchor, constant: -12),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            nameLabel.heightAnchor.constraint(equalToConstant: 20),
            
            avatarImageView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 8),
            avatarImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            avatarImageView.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -8),
            avatarImageView.widthAnchor.constraint(equalTo: avatarImageView.heightAnchor)
            
        ])
        
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
    
    @objc func addAction() {
        guard let searchedUser = searchedUser else { return }
        NetworkController.shared.add(friend: searchedUser.id) {  [weak self] (error) in
            guard let self = self else { return }
            if let error = error {
                NSLog(error.rawValue)
            }
            
            self.dismiss(animated: true)
            self.delegate?.friendAdded()
        }
    }
}

extension AddFriendVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        performSearchAction()
        return true
    }
    
    func performSearchAction() {
        guard let searchEmail = emailTextField.text?.lowercased(),
            !searchEmail.isEmpty else { return }
        NetworkController.shared.search(email: searchEmail) { [weak self] user, error in
            guard let self = self else { return }
            
            if let error = error {
                NSLog(error.rawValue)
            }
            
            guard let user = user else { return }
            self.searchedUser = user
            self.nameLabel.text = user.fullName
        }
    }
}
