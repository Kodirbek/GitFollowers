//
//  FavoritesListVC.swift
//  GitFollowers
//
//  Created by kodirbek on 1/5/24.
//

import UIKit

class FavoritesListVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBlue
        
        PersistenceManager.retrieveFavorites { result in
            switch result {
                case .success(let favorites):
                    print(favorites)
                case .failure(let error):
                    print(error)
            }
        }
    }
    

}
