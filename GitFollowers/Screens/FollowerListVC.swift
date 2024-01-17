//
//  FollowerListVC.swift
//  GitFollowers
//
//  Created by kodirbek on 1/8/24.
//

import UIKit

class FollowerListVC: UIViewController {
    
    // MARK: - Properties
    var username: String!
    var collectionView: UICollectionView!

    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        getFollowers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    // MARK: - Set up UI
    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewLayout())
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseId)
    }
    
    
    // MARK: - Mathods
    func getFollowers() {
        NetworkManager.shared.getFollowers(for: username, page: 1) { result in
            switch result {
                case .success(let followers):
                    print("Followers total: \(followers.count)")
                case .failure(let error):
                    self.presentGFAlertOnMainThread(title: "Error!", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    

}
