//
//  FollowerCell.swift
//  GitFollowers
//
//  Created by kodirbek on 1/17/24.
//

import UIKit

final class FollowerCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let reuseId          = "FollowerCell"
    private let padding         : CGFloat = 8
    private let avatarImageView = GFAvatarImageView(frame: .zero)
    private let userNameLabel   = GFTitleLabel(textAlignment: .center, fontSize: 16)
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        avatarImageView.image = Images.placeholder
        userNameLabel.text = ""
    }
    
    // MARK: - Methods
    func set(follower: Follower) {
        userNameLabel.text = follower.login
        avatarImageView.downloadImage(fromURL: follower.avatarUrl)
    }
    
    private func configure() {
        addSubviews(avatarImageView, userNameLabel)
        
        NSLayoutConstraint.activate([
            
            avatarImageView.topAnchor.constraint(equalTo        : topAnchor, constant: padding),
            avatarImageView.leadingAnchor.constraint(equalTo    : leadingAnchor, constant: padding),
            avatarImageView.trailingAnchor.constraint(equalTo   : trailingAnchor, constant: -padding),
            avatarImageView.heightAnchor.constraint(equalTo     : avatarImageView.widthAnchor),
            
            userNameLabel.topAnchor.constraint(equalTo          : avatarImageView.bottomAnchor, constant: 12),
            userNameLabel.leadingAnchor.constraint(equalTo      : leadingAnchor, constant: padding),
            userNameLabel.trailingAnchor.constraint(equalTo     : trailingAnchor, constant: -padding),
            userNameLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
