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
        return config.tumOnline.user.map { user in
            return self.fetch(for: user, maxCache: skipCache ? .no : .forever).map { (data: UserData) in
                user.data = data
                return user
            }
        } ?? .errored(with: .cannotPerformRequest)
    }
    
    func fetch(for data: User) -> Response<UserData> {
        return fetch(for: data, maxCache: .no)
    }

}

// MARK: Requests

extension UserDataManager {
    
    fileprivate func search(with id: String, maxCache: CacheTime) -> Response<UserData> {
        let manager = PersonSearchManager(config: config)
        return manager.search(query: id, maxCache: maxCache).flatMap { users in
            guard let user = users.first, users.count == 1 else {
                return .errored(with: .noData)
            }
            return .successful(with: user)
        }
    }
    
    fileprivate func fetch(for user: User, maxCache: CacheTime) -> Response<UserData> {
        guard let name = user.name else {
            return config.tumOnline.doRepresentedRequest(to: .identify,
                                                         maxCacheTime: maxCache).flatMap { (xml: XMLIndexer) in
                
                guard let first = xml.get(at: ["rowset", "row", "vorname"])?.element?.text,
                    let last = xml.get(at: ["rowset", "row", "familienname"])?.element?.text else {
                        
                        return .errored(with: .cannotPerformRequest)
                }
                let name = "\(first) \(last)"
                user.name = name
                return self.search(with: name, maxCache: maxCache)
            }
        }
        return search(with: name, maxCache: maxCache)
    }
    
}
