//
//  GFBodyLabel.swift
//  GitFollowers
//
//  Created by kodirbek on 1/8/24.
//

import UIKit

class GFBodyLabel: UILabel {
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(textAlignment: NSTextAlignment) {
        self.init(frame: .zero)
        self.textAlignment = textAlignment
    }
    
    // MARK: - Methods
    private func configure() {
        textColor                           = .secondaryLabel
        font                                = UIFont.preferredFont(forTextStyle: .body)
        adjustsFontForContentSizeCategory   = true
        adjustsFontSizeToFitWidth           = true
        minimumScaleFactor                  = 0.7
        lineBreakMode                       = .byWordWrapping
        translatesAutoresizingMaskIntoConstraints = false
    }
    
}
