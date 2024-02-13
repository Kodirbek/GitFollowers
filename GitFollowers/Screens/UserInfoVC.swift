//
//  UserInfoVC.swift
//  GitFollowers
//
//  Created by kodirbek on 1/27/24.
//

import UIKit

class UserInfoVC: UIViewController {
    
    // MARK: - Properties
    let headerView = UIView()
    var userName: String!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
        
        layoutUI()
        
        NetworkManager.shared.getUserInfo(for: userName) { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let user):
                    DispatchQueue.main.async {
                        self.add(childVC: GFUserInfoHeaderVC(user: user), to: self.headerView)
                    }
                case .failure(let error):
                    self.presentGFAlertOnMainThread(title: "Error", message: error.rawValue, buttonTitle: "Ok")
            }
        }

    }
    
    // MARK: - Layout
    func layoutUI() {
        view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180)
        ])
    }
    
    // MARK: - Add ChildVC
    func add(childVC: UIViewController, to containerView: UIView) {
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
