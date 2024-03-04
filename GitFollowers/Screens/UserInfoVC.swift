//
//  UserInfoVC.swift
//  GitFollowers
//
//  Created by kodirbek on 1/27/24.
//

import UIKit

protocol UserInfoVCDelegate: AnyObject {
    func didRequestFollowers(for user: String)
}

final class UserInfoVC: UIViewController {
    
    // MARK: - Properties
    private let scrollView  = UIScrollView()
    private let contentView = UIView()
    private let headerView  = UIView()
    private let itemViewOne = UIView()
    private let itemViewTwo = UIView()
    private let dateLabel   = GFBodyLabel(textAlignment: .center)
    private var itemViews   : [UIView] = []
    
    private var userName    : String
    weak var delegate       : UserInfoVCDelegate?
    
    // MARK: - Init
    init(username: String) {
        self.userName       = username
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureScrollView()
        layoutUI()
        getUserInfo()
    }
    
    // MARK: - ConfigureVC
    private func configureVC() {
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                         target: self,
                                         action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    private func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.pinToEdges(of: view)
        contentView.pinToEdges(of: scrollView)
        
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 620)
        ])
    }
    
    private func getUserInfo() {
        NetworkManager.shared.getUserInfo(for: userName) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
                case .success(let user):
                    DispatchQueue.main.async { self.configureUIElements(with: user) }
                case .failure(let error):
                    self.presentGFAlert(title: "Error",
                                        message: error.rawValue,
                                        buttonTitle: "Ok")
            }
        }
    }
    
    private func configureUIElements(with user: User) {
        self.add(childVC: GFUserInfoHeaderVC(user: user), 
                 to: self.headerView)
        self.add(childVC: GFRepoItemVC(user: user, delegate: self),
                 to: self.itemViewOne)
        self.add(childVC: GFFollowerItemVC(user: user, delegate: self),
                 to: self.itemViewTwo)
        
        self.dateLabel.text = "GitHub since \(user.createdAt.convertToMonthYearFormat())"
    }
    
    // MARK: - Layout
    private func layoutUI() {
        
        let padding: CGFloat    = 20
        let itemHeight: CGFloat = 140
        itemViews = [headerView, itemViewOne, itemViewTwo, dateLabel]
        
        for itemView in itemViews {
            contentView.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo       : contentView.leadingAnchor, constant: padding),
                itemView.trailingAnchor.constraint(equalTo      : contentView.trailingAnchor, constant: -padding)
            ])
        }
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo             : contentView.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant  : 210),
            
            itemViewOne.topAnchor.constraint(equalTo            : headerView.bottomAnchor, constant: padding),
            itemViewOne.heightAnchor.constraint(equalToConstant : itemHeight),
            
            itemViewTwo.topAnchor.constraint(equalTo            : itemViewOne.bottomAnchor, constant: padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant : itemHeight),
            
            dateLabel.topAnchor.constraint(equalTo              : itemViewTwo.bottomAnchor, constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant   : 18)
        ])
    }
    
    // MARK: - Add ChildVC
    private func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
    
    // MARK: - Methods
    @objc func dismissVC() {
        dismiss(animated: true)
    }

}

// MARK: - Extensions
extension UserInfoVC: GFRepoItemVCDelegate {
    func didTapGitHubProfile(for user: User) {
        guard let url = URL(string: user.htmlUrl) else {
            presentGFAlert(title:       "Invalid URL",
                           message:     "This user's url is invalid,",
                           buttonTitle: "Ok")
            return
        }
        
        presentSafariWith(with: url)
    }
}

extension UserInfoVC: GFFollowerItemVCDelegate {
    func didTapGitHubFollowers(for user: User) {
        guard user.followers != 0 else {
            presentGFAlert(title:       "No Followers",
                           message:     "This user has no followers!",
                           buttonTitle: "Ok")
            return
        }
        delegate?.didRequestFollowers(for: user.login)
        dismissVC()
    }
}
