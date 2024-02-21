//
//  FollowerListVC.swift
//  GitFollowers
//
//  Created by kodirbek on 1/8/24.
//

import UIKit

enum Section {
    case main
}

protocol FollowerListVCDelegate: AnyObject {
    func didRequestFollowers(for user: String)
}

final class FollowerListVC: UIViewController {
    
    // MARK: - Properties
    private var username             : String
    private var followers            : [Follower] = []
    private var filteredFollowers    : [Follower] = []
    private var page                 = 1
    private var hasMoreFollowers     = true
    private var isSearching          : Bool = false
    
    private var collectionView       : UICollectionView!
    private var dataSource           : UICollectionViewDiffableDataSource<Section, Follower>!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureSearchController()
        configureCollectionView()
        configureDataSource()
        getFollowers(username: username, page: page)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - Init
    init(username: String) {
        self.username   = username
        super.init(nibName: nil, bundle: nil)
        title           = username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("FollowerListVC deinitialized()")
    }
    
    
    // MARK: - Set up UI
    private func configureViewController() {
        view.backgroundColor                    = .systemBackground
        navigationController?
            .navigationBar.prefersLargeTitles   = true
        
        let addButton = UIBarButtonItem(barButtonSystemItem : .add,
                                        target              : self,
                                        action              : #selector(addButtonTapped))
        
        navigationItem.rightBarButtonItem                   = addButton
    }
    
    
    // MARK: - Collection View configure
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds,
                                          collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, 
                                forCellWithReuseIdentifier: FollowerCell.reuseId)
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView,
                                                                           cellProvider: { (collectionView,
                                                                                            indexPath,
                                                                                            follower) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseId, 
                                                          for: indexPath) as? FollowerCell
            cell?.set(follower: follower)
            return cell
        })
    }
    
    private func updateData(on followers: [Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    @objc func addButtonTapped() {
        showLoading()
        
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self = self else { return }
            hideLoading()
            
            switch result {
                case .success(let user):
                    let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)
                    
                    PersistenceManager.updateWith(favorite: favorite, actionType: .add) { error in
                        
                        guard let error = error else {
                            self.presentGFAlertOnMainThread(title: "Success!", 
                                                            message: "User has been added successfully!",
                                                            buttonTitle: "Ok")
                            return
                        }
                        
                        self.presentGFAlertOnMainThread(title: "Error",
                                                        message: error.rawValue,
                                                        buttonTitle: "Ok")
                        
                    }
                case .failure(let error):
                    self.presentGFAlertOnMainThread(title: "Error", 
                                                    message: error.rawValue,
                                                    buttonTitle: "Ok")
            }
        }
    }
    
    // MARK: - SearchController
    private func configureSearchController() {
        let searchController                    = UISearchController()
        searchController.searchResultsUpdater   = self
        searchController.searchBar.delegate     = self
        searchController.searchBar.placeholder  = "Search for a username"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController         = searchController
    }
    
    
    // MARK: - API Method
    private func getFollowers(username: String, page: Int) {
        showLoading()
        NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] result in
            guard let self = self else { return }
            
            self.hideLoading()
            
            switch result {
                case .success(let followers):
                    if followers.count < 100 { self.hasMoreFollowers = false }
                    self.followers.append(contentsOf: followers)
                    
                    // check for the condition where the user might have no followers
                    if self.followers.isEmpty {
                        let message = "This user does not have any followers. Go follow them 😀"
                        DispatchQueue.main.async {
                            self.showEmptyStateView(with: message, in: self.view)
                        }
                        return
                    }
                    
                    self.updateData(on: self.followers)
                    
                case .failure(let error):
                    self.presentGFAlertOnMainThread(title: "Error!", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
}

// MARK: - CollectionView Delegate Methods
extension FollowerListVC: UICollectionViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            guard hasMoreFollowers else { return }
            page += 1
            getFollowers(username: username, page: page)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeArray         = isSearching ? filteredFollowers : followers
        let follower            = activeArray[indexPath.item]
        
        let destinationVC       = UserInfoVC(username: follower.login)
        destinationVC.delegate  = self
        let navController       = UINavigationController(rootViewController: destinationVC)
        present(navController, animated: true)
    }
    
}

// MARK: - SearchController delegate methods
extension FollowerListVC: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else { return }
        isSearching = true
        filteredFollowers = followers.filter { $0.login.lowercased().contains(filter.lowercased()) }
        updateData(on: filteredFollowers)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        updateData(on: followers)
        filteredFollowers = []
    }
}

// MARK: - FollowerListVCProtocol delegate
extension FollowerListVC: FollowerListVCDelegate {
    func didRequestFollowers(for user: String) {
        self.username = user
        title = username
        page = 1
        followers.removeAll()
        filteredFollowers.removeAll()
        collectionView.setContentOffset(.zero, animated: true)
        
        getFollowers(username: username, page: page)
    }
}
