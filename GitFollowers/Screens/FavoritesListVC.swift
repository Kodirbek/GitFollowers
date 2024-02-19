//
//  FavoritesListVC.swift
//  GitFollowers
//
//  Created by kodirbek on 1/5/24.
//

import UIKit

class FavoritesListVC: UIViewController {

    // MARK: - Properties
    private let tableView: UITableView = UITableView()
    private var favorites: [Follower] = []
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        getFavorites()
        
    }
    
    
    // MARK: - Methods
    private func configureViewController() {
        self.view.backgroundColor = .systemBackground
        title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func getFavorites() {
        PersistenceManager.retrieveFavorites { [weak self] result in
            switch result {
                case .success(let favorites):
                    self?.favorites = favorites
                case .failure(let error):
                    print(error)
            }
        }
    }
}


// MARK: - UITableView delegate methods
extension FavoritesListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
}
