//
//  UIViewController+Extension.swift
//  GitFollowers
//
//  Created by kodirbek on 1/10/24.
//

import UIKit
import SafariServices

extension UIViewController {
    
    func presentGFAlert(title: String,
                        message: String,
                        buttonTitle: String) {
        let alertVC = GFAlertVC(alertTitle: title,
                                message: message,
                                buttonTitle: buttonTitle)
        alertVC.modalPresentationStyle  = .overFullScreen
        alertVC.modalTransitionStyle    = .crossDissolve
        self.present(alertVC, animated: true)
    }
    
    func presentDefaultError() {
        let alertVC = GFAlertVC(alertTitle: "Something went wrong",
                                message: "Unable to complete the task now. Please try again.",
                                buttonTitle: "Ok")
        alertVC.modalPresentationStyle  = .overFullScreen
        alertVC.modalTransitionStyle    = .crossDissolve
        self.present(alertVC, animated: true)
    }
    
    func presentSafariWith(with url: URL) {
        let safariVC                        = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor  = .systemGreen
        present(safariVC, animated: true)
    }
    
}
