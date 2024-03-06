//
//  GFEmptyStateView.swift
//  GitFollowers
//
//  Created by kodirbek on 1/20/24.
//

import UIKit

class GFEmptyStateView: UIImageView {
    
    // MARK: - Properties
    
    let messageLabel    = GFTitleLabel(textAlignment: .center, fontSize: 28)
    let logoImageView   = UIImageView()

    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureMessageLabel()
        configureLogoImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(message: String) {
        self.init(frame: .zero)
        messageLabel.text = message
    }
    
    
    // MARK: - Methods
    
    private func configureMessageLabel() {
        addSubview(messageLabel)
        messageLabel.numberOfLines  = 3
        messageLabel.textColor      = .secondaryLabel
        
        let messageLabelTopConstant: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? -80 : -150
        
        NSLayoutConstraint.activate([
            messageLabel.centerYAnchor.constraint(equalTo   : self.centerYAnchor, constant: messageLabelTopConstant),
            messageLabel.leadingAnchor.constraint(equalTo   : self.leadingAnchor, constant: 40),
            messageLabel.trailingAnchor.constraint(equalTo  : self.trailingAnchor, constant: -40),
            messageLabel.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    
    private func configureLogoImageView() {
        addSubview(logoImageView)
        logoImageView.image         = Images.emptyState
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let logoBottomConstant: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? 80 : 40
        
        NSLayoutConstraint.activate([
            logoImageView.widthAnchor.constraint(equalTo    : self.widthAnchor, multiplier: 1.3),
            logoImageView.heightAnchor.constraint(equalTo   : self.widthAnchor, multiplier: 1.3),
            logoImageView.trailingAnchor.constraint(equalTo : self.trailingAnchor, constant: 170),
            logoImageView.bottomAnchor.constraint(equalTo   : self.safeAreaLayoutGuide.bottomAnchor, constant: logoBottomConstant)
        ])
    }
}
