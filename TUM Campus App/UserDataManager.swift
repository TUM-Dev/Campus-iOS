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
        }
        return config.tumOnline.user.map { user in
            return self.fetch(for: user, maxCache: .forever).map { (data: UserData) in
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
            return config.tumOnline.doRepresentedRequest(to: .identify,
                                                         maxCacheTime: maxCache).flatMap { (xml: XMLIndexer) in
                
                guard let first = xml.get(at: ["rowset", "row", "vorname"])?.element?.text,
                    let last = xml.get(at: ["rowset", "row", "familienname"])?.element?.text,
                    let id = xml.get(at: ["rowset", "row", "obfuscated_id"])?.element?.text else {
                        
                        return .errored(with: .invalidResponse)
                }
                
                let key = CurrentAccountType.value.key
                let currentId = xml.get(at: ["rowset", "row", "obfuscated_ids", key])?.element?.text
                let picture = currentId?.imageURL(in: self.config)
                                                            
                let name = "\(first) \(last)"
                return .successful(with: .init(name: name, picture: picture, id: id, maxCache: maxCache))
            }
        }
        return search(with: name, maxCache: maxCache)
    }
    
}

fileprivate extension String {
    
    func imageURL(in config: Config) -> String? {
        
        let split = self.components(separatedBy: "*")
        guard split.count == 2 else { return nil }
        
        return config.tumOnline
                     .base
                     .appendingPathComponent("visitenkarte.showImage")
                     .appendingQuery(key: "pPersonenGruppe", value: split[0])
                     .appendingQuery(key: "pPersonenId", value: split[1])
                     .absoluteString
    }
    
}
