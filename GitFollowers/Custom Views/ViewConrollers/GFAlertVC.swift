//
//  GFAlertVC.swift
//  GitFollowers
//
//  Created by kodirbek on 1/9/24.
//

import UIKit

final class GFAlertVC: UIViewController {
    
    
    // MARK: - Properties
    
    private let containerView       = GFAlertContainerView()
    private let titleLabel          = GFTitleLabel(textAlignment: .center, fontSize: 20)
    private let messageLabel        = GFBodyLabel(textAlignment: .center)
    private let actionButton        = GFButton(color: .systemPink, title: "Ok", systemImage: "checkmark.circle")

    private var alertTitle          : String?
    private var message             : String?
    private var buttonTitle         : String?
    
    private let padding: CGFloat    = 20
    
    
    // MARK: - Init
    
    init(alertTitle: String, message: String, buttonTitle: String) {
        super.init(nibName: nil, bundle: nil)
        self.alertTitle     = alertTitle
        self.message        = message
        self.buttonTitle    = buttonTitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        
        addSubviews()
        initialConfigure()
        layoutUI()
    }
    
    
    // MARK: - Set up UI
    
    private func addSubviews() {
        self.view.addSubviews(containerView, titleLabel, actionButton, messageLabel)
    }
    
    private func initialConfigure() {
        titleLabel.text             = alertTitle ?? "Error occured"
        
        actionButton.setTitle(buttonTitle ?? "OK",
                              for: .normal)
        actionButton.addTarget(self,
                               action: #selector(dismissVC),
                               for: .touchUpInside)
        
        messageLabel.text           = message ?? "Unable to complete request"
        messageLabel.numberOfLines  = 4
    }
    
    private func layoutUI() {
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo:         self.view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo:         self.view.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant:   280),
            containerView.heightAnchor.constraint(equalToConstant:  220),
            
            titleLabel.topAnchor.constraint(equalTo:                containerView.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo:            containerView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo:           containerView.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant:     28),
            
            actionButton.bottomAnchor.constraint(equalTo:           containerView.bottomAnchor, constant: -padding),
            actionButton.leadingAnchor.constraint(equalTo:          containerView.leadingAnchor, constant: padding),
            actionButton.trailingAnchor.constraint(equalTo:         containerView.trailingAnchor, constant: -padding),
            actionButton.heightAnchor.constraint(equalToConstant:   44),
            
            messageLabel.topAnchor.constraint(equalTo:              titleLabel.bottomAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo:          containerView.leadingAnchor, constant: padding),
            messageLabel.trailingAnchor.constraint(equalTo:         containerView.trailingAnchor, constant: -padding),
            messageLabel.bottomAnchor.constraint(equalTo:           actionButton.topAnchor, constant: -12)
        ])
    }
    
    // MARK: - Methods
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
    

}
