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
    
    func search(with id: String) -> Promise<UserData, APIError> {
        let manager = PersonSearchManager(config: config)
        return manager.search(query: id).nested { users, promise in
            guard let user = users.first else {
                return promise.error(with: .noData)
            }
            promise.success(with: user)
        }
    }
    
    func fetch(for data: User) -> Promise<UserData, APIError> {
        guard let id = data.id else {
            return config.tumOnline.doRepresentedRequest(to: .identify).next { (xml: XMLIndexer) in
                guard let id = xml["id"].element?.text else {
                    return .errored(with: .cannotPerformRequest)
                }
                return self.search(with: id)
            }
        }
        return search(with: id)
    }

}
