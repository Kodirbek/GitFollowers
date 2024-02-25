//
//  UIView+Extension.swift
//  GitFollowers
//
//  Created by kodirbek on 2/25/24.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        for view in views { addSubview(view) }
    }
}
