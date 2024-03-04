//
//  FollowerListVC.swift
//  GitFollowers
//
//  Created by kodirbek on 1/8/24.
//

import UIKit

enum Section { case main }

final class FollowerListVC: GFDataLoadingVC {
    
    // MARK: - Properties
    private var username             : String
    private var followers            : [Follower] = []
    private var filteredFollowers    : [Follower] = []
    private var page                 = 1
    private var hasMoreFollowers     = true
    private var isSearching          : Bool = false
    private var isLoadingFollowers   : Bool = false
    
    private var searchController     : UISearchController!
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
    
    // MARK: - SearchController
    private func configureSearchController() {
        searchController                        = UISearchController()
        searchController.searchResultsUpdater   = self
        searchController.searchBar.placeholder  = "Search for a username"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController         = searchController
    }
    
    // MARK: - Add button action (persistence)
    @objc func addButtonTapped() {
        showLoading()
        
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self = self else { return }
            hideLoading()
            
            switch result {
                case .success(let user):
                    self.addUserToFavorites(user: user)
                    
                case .failure(let error):
                    self.presentGFAlert(title: "Error",
                                        message: error.rawValue,
                                        buttonTitle: "Ok")
            }
        }
    }
    
    private func addUserToFavorites(user: User) {
        let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)
        
        PersistenceManager.updateWith(favorite: favorite, actionType: .add) { error in
            
            guard let error = error else {
                self.presentGFAlert(title: "Success!",
                                    message: "User has been added successfully!",
                                    buttonTitle: "Ok")
                return
            }
            
            self.presentGFAlert(title: "Error",
                                message: error.rawValue,
                                buttonTitle: "Ok")
            
        }
    }
    
    // MARK: - Get Followers, update UI
    private func getFollowers(username: String, page: Int) {
        showLoading()
        isLoadingFollowers = true
        
        Task {
            do {
                let followers = try await NetworkManager.shared.getFollowers(for: username, page: page)
                updateUI(with: followers)
                hideLoading()
            } catch {
                if let gfError = error as? GFError {
                    presentGFAlert(title: "Error occurred", message: gfError.rawValue, buttonTitle: "Ok")
                } else {
                    presentDefaultError()
                }
                
                hideLoading()
            }
        }
        
        isLoadingFollowers = false
    }
    
    private func updateData(on followers: [Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    private func updateUI(with followers: [Follower]) {
        if followers.count < 100 { self.hasMoreFollowers = false }
        self.followers.append(contentsOf: followers)
        
        // check for the condition where the user might have no followers
        if self.followers.isEmpty {
            DispatchQueue.main.async {
                self.searchController.searchBar.isHidden = true
                self.showEmptyStateView(with: emptyMessage,
                                        in: self.view)
            }
            return
        }
        
        self.updateData(on: self.followers)
    }
}

// MARK: - CollectionView Delegate Methods
extension FollowerListVC: UICollectionViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            guard hasMoreFollowers, !isLoadingFollowers else { return }
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
extension FollowerListVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            filteredFollowers.removeAll()
            updateData(on: followers)
            isSearching = false
            return
        }
        
        isSearching = true
        filteredFollowers = followers.filter { $0.login.lowercased().contains(filter.lowercased()) }
        updateData(on: filteredFollowers)
    }
}

// MARK: - FollowerListVCProtocol delegate
extension FollowerListVC: UserInfoVCDelegate {
    func didRequestFollowers(for user: String) {
        self.username = user
        title = username
        page = 1
        
        followers.removeAll()
        filteredFollowers.removeAll()
        collectionView.scrollToItem(
            at: IndexPath(item: 0, section: 0),
            at: .top,
            animated: true)
        
        getFollowers(username: username, page: page)
    }
}
