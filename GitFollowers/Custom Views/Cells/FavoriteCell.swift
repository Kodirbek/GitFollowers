//
//  FavoriteCell.swift
//  GitFollowers
//
//  Created by kodirbek on 2/20/24.
//

import UIKit

final class FavoriteCell: UITableViewCell {

    // MARK: - Properties
    static let reuseId          = "FavoriteCell"
    private let avatarImageView = GFAvatarImageView(frame: .zero)
    private let userNameLabel   = GFTitleLabel(textAlignment: .left, fontSize: 26)
    
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    func set(favorite: Follower) {
        userNameLabel.text = favorite.login
        NetworkManager.shared.downloadImage(from: favorite.avatarUrl) { [weak self] image in
            DispatchQueue.main.async { self?.avatarImageView.image = image }
        }
    }
    
    private func configure() {
        addSubviews(avatarImageView, userNameLabel)
        
        accessoryType = .disclosureIndicator
        let padding: CGFloat = 12
        
        NSLayoutConstraint.activate([
            avatarImageView.centerYAnchor.constraint(equalTo        : self.centerYAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo        : self.leadingAnchor, constant: padding),
            avatarImageView.heightAnchor.constraint(equalToConstant : 60),
            avatarImageView.widthAnchor.constraint(equalToConstant  : 60),
            
            userNameLabel.centerYAnchor.constraint(equalTo          : self.centerYAnchor),
            userNameLabel.leadingAnchor.constraint(equalTo          : avatarImageView.trailingAnchor, constant: 24),
            userNameLabel.trailingAnchor.constraint(equalTo         : self.trailingAnchor, constant: -padding),
            userNameLabel.heightAnchor.constraint(equalToConstant   : 40)
        ])
    }
}
