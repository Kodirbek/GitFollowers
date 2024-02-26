//
//  GFTitleLabel.swift
//  GitFollowers
//
//  Created by kodirbek on 1/8/24.
//

import UIKit

class GFTitleLabel: UILabel {

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(textAlignment: NSTextAlignment, fontSize: CGFloat) {
        self.init(frame: .zero)
        self.textAlignment      = textAlignment
        self.font               = UIFont.systemFont(ofSize: fontSize, weight: .bold)
    }
    
    // MARK: - Methods
    private func configure() {
        textColor               = .label
        minimumScaleFactor      = 0.9
        lineBreakMode           = .byTruncatingTail
        adjustsFontSizeToFitWidth = true
        translatesAutoresizingMaskIntoConstraints = false
    }

}
