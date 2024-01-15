//
//  NetworkManager.swift
//  GitFollowers
//
//  Created by kodirbek on 1/15/24.
//

import Foundation


class NetworkManager {
    static let shared = NetworkManager()
    let baseUrl = "https://api.github.com/users/"
    
    private init() {}
    
    func getFollowers(for username: String, page: Int, completed: @escaping ([Follower]?, String?) -> Void) {
        // url
        let urlString = baseUrl + "\(username)/followers?per_page=100&page=\(page)"
        guard let url = URL(string: urlString) else {
            completed(nil, "Invalid url!")
            return
        }
        
        // task
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completed(nil, "Internet error!")
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(nil, "Invalid response!")
                return
            }
            
            guard let data = data else {
                completed(nil, "Invalid data")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let followers = try decoder.decode([Follower].self, from: data)
                completed(followers, nil)
            } catch {
                completed(nil, "Invalid data!")
            }
        }
        
        // resume
        task.resume()
    }
    
}
