//
//  GFButton.swift
//  GitFollowers
//
//  Created by kodirbek on 1/7/24.
//

import UIKit

class GFButton: UIButton {

    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    convenience init(color: UIColor, title: String, systemImage: String) {
        self.init(frame: .zero)
        set(color: color, title: title, systemImage: systemImage)
    }
    
    // MARK: - UI
    
    private func configure() {
        configuration = .tinted()
        configuration?.cornerStyle = .medium
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    final func set(color: UIColor, title: String, systemImage: String) {
        configuration?.baseBackgroundColor = color
        configuration?.baseForegroundColor = color
        configuration?.title = title
        
        configuration?.image = UIImage(systemName: systemImage)
        configuration?.imagePadding = 6
        configuration?.imagePlacement = .leading
    }
    
}
