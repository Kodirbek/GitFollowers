//
//  ViewController.swift
//  GitFollowers
//
//  Created by kodirbek on 1/4/24.
//

import UIKit

final class SearchVC: UIViewController {
    
    // MARK: - Properties
    private let logoImageView                   = UIImageView()
    private let usernameTextField               = GFTextField()
    private let callToActionButton              = GFButton(color: .systemGreen, title: "Get Followers", systemImage: "person.3")
    
    private var isUsernameEntered               : Bool { !usernameTextField.text!.isEmpty }

    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor            = .systemBackground
        addSubviews()
        initialConfigure()
        layoutUI()
        createDismissKeyboardTapGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true,
                                                     animated: true)
    }

    // MARK: - Set up UI
    private func addSubviews() {
        view.addSubviews(logoImageView, usernameTextField,callToActionButton)
    }
    
    private func initialConfigure() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = Images.ghLogo
        usernameTextField.delegate = self
        callToActionButton.addTarget(self, action: #selector(pushFollowerListVC), for: .touchUpInside)
    }
    
    // LogoImageView
    private func layoutUI() {
        let topConstraintConstant: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? 20 : 80
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo                  : view.safeAreaLayoutGuide.topAnchor, constant: topConstraintConstant),
            logoImageView.centerXAnchor.constraint(equalTo              : view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant       : 200),
            logoImageView.widthAnchor.constraint(equalToConstant        : 200),
            
            usernameTextField.topAnchor.constraint(equalTo              : logoImageView.bottomAnchor, constant: 48),
            usernameTextField.leadingAnchor.constraint(equalTo          : view.leadingAnchor, constant: 50),
            usernameTextField.trailingAnchor.constraint(equalTo         : view.trailingAnchor, constant: -50),
            usernameTextField.heightAnchor.constraint(equalToConstant   : 50),
            
            callToActionButton.bottomAnchor.constraint(equalTo          : view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            callToActionButton.leadingAnchor.constraint(equalTo         : view.leadingAnchor, constant: 50),
            callToActionButton.trailingAnchor.constraint(equalTo        : view.trailingAnchor, constant: -50),
            callToActionButton.heightAnchor.constraint(equalToConstant  : 50)
        ])
    }
    
    
    // MARK: - Methods
    
    private func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: view, 
                                         action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    
    @objc func pushFollowerListVC() {
        guard isUsernameEntered else {
            presentGFAlertOnMainThread(title        : "Empty Username",
                                       message      : "Please enter a username.",
                                       buttonTitle  : "Ok")
            return
        }
        
        guard let username = usernameTextField.text else { return }
        let followerListVC = FollowerListVC(username: username)
        navigationController?.pushViewController(followerListVC, animated: true)
        usernameTextField.text = ""
    }
}

// MARK: - Extension
extension SearchVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushFollowerListVC()
        textField.resignFirstResponder()
        return true
    }
}

