//
//  GFRepoItemVC.swift
//  GitFollowers
//
//  Created by kodirbek on 2/15/24.
//

import UIKit

class GFRepoItemVC: GFItemInfoVC {
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
        configureButton()
    }
    
    // MARK: - Methods
    private func configureItems() {
        itemInfoViewOne.set(itemInfoType: .repos, count: user.publicRepos)
        itemInfoViewTwo.set(itemInfoType: .gists, count: user.publicGists)
    }
    
    private func configureButton() {
        actionButton.set(backgroundColor: .systemPurple, title: "GitHub Profile")
    }
    
    override func actionButtonTapped() {
        delegate?.didTapGitHubProfile()
    }
}
