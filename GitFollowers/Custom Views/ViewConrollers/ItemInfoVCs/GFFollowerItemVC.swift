//
//  GFFollowerItemVC.swift
//  GitFollowers
//
//  Created by kodirbek on 2/15/24.
//

import UIKit

class GFFollowerItemVC: GFItemInfoVC {
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
        configureButton()
    }
    
    // MARK: - Methods
    private func configureItems() {
        itemInfoViewOne.set(itemInfoType: .followers, count: user.followers)
        itemInfoViewTwo.set(itemInfoType: .following, count: user.following)
    }
    
    private func configureButton() {
        actionButton.set(backgroundColor: .systemGreen, title: "Git Followers")
    }
}
