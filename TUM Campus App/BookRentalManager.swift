//
//  File.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 19.04.17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import Foundation
import Sweeft
import Kanna

final class BookRentalManager: SingleItemManager, CardManager {
    
    typealias DataType = BookRental
    
    var config: Config
    
    var requiresLogin: Bool {
        return false
    }
    
    var cardKey: CardKey {
        return .bookRental
    }
    
    init(config: Config) {
        self.config = config
    }
    
    func fetch() -> Response<[BookRental]> {
        let api = config.bookRentals
        return api.start().flatMap { csid in
            
            return api.login(user: self.getUsername(),
                             password: self.getPassword(),
                             csid: csid)
        }
        .flatMap { session in
            // TODO: store session maybe
            return api.rentals()
        }
        .mapError(to: .empty)
    }
    
    func getUsername() -> String {
        return UserDefaults.standard.value(forKey: "username") as? String ?? ""
    }
    
    func getPassword() -> String {
        return KeychainWrapper().myObject(forKey: "v_Data") as? String ?? ""
    }
    
    func saveInKeychain(username: String, password: String) {
        
        let keychainWrapper = KeychainWrapper()
        
        UserDefaults.standard.set(username, forKey: "username")
        UserDefaults.standard.set(true, forKey: "hasSavedPassword")
        keychainWrapper.mySetObject(password, forKey: kSecValueData)
        keychainWrapper.writeToKeychain()
        UserDefaults.standard.synchronize()
    }
    
    func login(username: String, password: String) -> Response<Bool> {
        let api = config.bookRentals
        return api.start().flatMap { (csid: String) in
            return api.login(user: username, password: password, csid: csid)
        }
        .map { (result: BookRentalAPISession) in
            self.saveInKeychain(username: username, password: password)
            return true
        }
    }
    
}
