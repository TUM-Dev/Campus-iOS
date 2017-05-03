//
//  File.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 19.04.17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import Foundation
import Alamofire
import Sweeft
import Kanna

final class NewBookRentalManager: CachedManager, SingleItemManager {
    
    typealias DataType = BookRental
    
    var config: Config
    
    var cache = [BookRental]()
    var isLoaded = false
    
    var requiresLogin: Bool {
        return false
    }
    
    init(config: Config) {
        self.config = config
    }
    
    func perform() -> Response<[BookRental]> {
        let api = config.bookRentals
        return api.start().next { csid in
            return api.login(user: self.getUsername(), password: self.getPassword(), csid: csid)
        }
        .next { session in
            // TODO: store session maybe
            return api.rentals()
        }
    }
    
    func getUsername() -> String {
        return UserDefaults.standard.value(forKey: "username") as? String ?? ""
    }
    
    func getPassword() -> String {
        return KeychainWrapper().myObject(forKey: "v_Data") as? String ?? ""
    }
    
}
