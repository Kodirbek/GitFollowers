//
//  GFRepoItemVC.swift
//  GitFollowers
//
//  Created by kodirbek on 2/15/24.
//

import UIKit

protocol GFRepoItemVCDelegate: AnyObject {
    func didTapGitHubProfile(for user: User)
}

class GFRepoItemVC: GFItemInfoVC {
    
    // MARK: - Properties
    weak var delegate: GFRepoItemVCDelegate?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
        configureButton()
    }
    
    // MARK: - Methods
    private func configureItems() {
        itemInfoViewOne.set(itemInfoType: .repos, 
                            count: user.publicRepos)
        itemInfoViewTwo.set(itemInfoType: .gists, 
                            count: user.publicGists)
    }
    
    private func configureButton() {
        actionButton.set(backgroundColor: .systemPurple, 
                         title: "GitHub Profile")
    }
    
    override func actionButtonTapped() {
        delegate?.didTapGitHubProfile(for: self.user)
    }
}
