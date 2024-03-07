//
//  FavoritesListVC.swift
//  GitFollowers
//
//  Created by kodirbek on 1/5/24.
//

import UIKit

final class FavoritesListVC: GFDataLoadingVC {

    // MARK: - Properties
    private let tableView           : UITableView = UITableView()
    private var favorites           : [Follower] = []
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavorites()
    }
    
    
    // MARK: - Content unavailable configuration
    override func updateContentUnavailableConfiguration(using state: UIContentUnavailableConfigurationState) {
        if favorites.isEmpty {
            var config = UIContentUnavailableConfiguration.empty()
            config.image = .init(systemName: "star")
            config.imageProperties.tintColor = .systemGreen
            config.text = "No Favorites"
            config.secondaryText = "You can add a favorite on the follower list screen."
            contentUnavailableConfiguration = config
        } else {
            contentUnavailableConfiguration = nil
        }
    }
    
    // MARK: - Methods
    private func configureViewController() {
        self.view.backgroundColor   = .systemBackground
        title                       = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.frame             = view.bounds
        tableView.rowHeight         = 80
        tableView.delegate          = self
        tableView.dataSource        = self
        tableView.removeExcessCells()
        tableView.register(FavoriteCell.self,
                           forCellReuseIdentifier: FavoriteCell.reuseId)
    }
    
    private func getFavorites() {
        PersistenceManager.retrieveFavorites { [weak self] result in
            guard let self else { return }
            switch result {
                case .success(let favorites):
                    self.updateUI(with: favorites)
                    
                case .failure(let error):
                    self.presentGFAlert(title       : "Something went wrong",
                                        message     : error.rawValue,
                                        buttonTitle : "Ok")
            }
        }
    }
    
    private func updateUI(with favorites: [Follower]) {
        self.favorites = favorites
        setNeedsUpdateContentUnavailableConfiguration()
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.view.bringSubviewToFront(self.tableView)
        }
    }
}


// MARK: - UITableView delegate methods
extension FavoritesListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.reuseId) as? FavoriteCell
        guard let cell else { return UITableViewCell() }
        
        let favorite = favorites[indexPath.row]
        cell.set(favorite: favorite)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favorite = favorites[indexPath.row]
        let destVC = FollowerListVC(username: favorite.login)
        
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        PersistenceManager.updateWith(favorite: favorites[indexPath.row], 
                                      actionType: .remove) { [weak self] error in
            guard let self else { return }
            guard let error else {
                favorites.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .left)
                setNeedsUpdateContentUnavailableConfiguration()
                return
            }
            
            self.presentGFAlert(title: "Unable to remove",
                                message: error.rawValue,
                                buttonTitle: "Ok")
        }
    }
}
