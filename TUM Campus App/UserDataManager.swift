//
//  UserDataManager.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/8/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Foundation
import Sweeft
import SWXMLHash

final class UserDataManager: DetailsForDataManager {
    
    typealias DataType = User
    typealias ResponseType = UserData
    
    let config: Config
    
    init(config: Config) {
        self.config = config
    }
    
    func fetch(skipCache: Bool = false) -> Response<User> {
        if skipCache {
            Data.cache.clear()
            config.tumOnline.removeCache(for: .identify)
        }
        return config.tumOnline.user.map { user in
            return self.fetch(for: user, maxCache: .forever).map { (data: UserData) in
                user.data = data
                return user
            }
            .mapResult { (result: Result<User, APIError>)  in
                if case .error = result {
                    user.data = nil
                }
                return result
            }
        } ?? .errored(with: .cannotPerformRequest)
    }
    
    func fetch(for data: User) -> Response<UserData> {
        return fetch(for: data, maxCache: .no)
    }

}

// MARK: Requests

extension UserDataManager {
    
    fileprivate func search(with name: String, maxCache: CacheTime) -> Response<UserData> {
        let manager = PersonSearchManager(config: config)
        return manager.search(query: name, maxCache: maxCache).flatMap { users in
            
            guard let user = users.first, users.count == 1 else {
                return .errored(with: .noData)
            }
            return .successful(with: user)
        }
    }
    
    fileprivate func fetch(for user: User, maxCache: CacheTime) -> Response<UserData> {
        guard let name = user.name else {
            return config.tumOnline.doXMLObjectRequest(to: .identify,
                                                       at: "rowset", "row",
                                                       maxCacheTime: maxCache)
        }
        return search(with: name, maxCache: maxCache)
    }
    
}
