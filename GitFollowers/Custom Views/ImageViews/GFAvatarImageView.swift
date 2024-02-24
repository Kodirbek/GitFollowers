//
//  GFAvatarImageView.swift
//  GitFollowers
//
//  Created by kodirbek on 1/17/24.
//

import UIKit

class GFAvatarImageView: UIImageView {
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Methods
    
    private func configure() {
        layer.cornerRadius  = 10
        clipsToBounds       = true
        image               = Images.placeholder
        translatesAutoresizingMaskIntoConstraints = false
    }
}
