//
//  GFFollowerItemVC.swift
//  GitFollowers
//
//  Created by kodirbek on 2/15/24.
//

import UIKit

protocol GFFollowerItemVCDelegate: AnyObject {
    func didTapGitHubFollowers(for user: User)
}

class GFFollowerItemVC: GFItemInfoVC {
    
    // MARK: - Properties
    weak var delegate: GFFollowerItemVCDelegate?
    
    // MARK: - Init
    init(user: User, delegate: GFFollowerItemVCDelegate) {
        super.init(user: user)
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
        configureButton()
    }
    
    // MARK: - Methods
    private func configureItems() {
        itemInfoViewOne.set(itemInfoType: .followers, 
                            count: user.followers)
        itemInfoViewTwo.set(itemInfoType: .following, 
                            count: user.following)
    }
    
    private func configureButton() {
        actionButton.set(color: .systemGreen, 
                         title: "Git Followers",
                         systemImage: "person.3")
    }
    
    override func actionButtonTapped() {
        delegate?.didTapGitHubFollowers(for: self.user)
    }
}
