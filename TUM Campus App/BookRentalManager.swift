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


class BookRentalManager: Manager {

    let opac_url = TumOPACApi.OpacURL.rawValue
    var main: TumDataManager
    
    required init(mainManager: TumDataManager) {
        main = mainManager
    }
    
    static var rentals = [DataElement]()


    func fetchData(_ handler: @escaping ([DataElement]) -> ()) {
        
        let api = BookRentalAPI(baseURL: opac_url)
        
        api.start().onSuccess { csid in
            return api.login(user: self.getUsername(), password: self.getPassword(), csid: csid)
        }
        .future
        .onSuccess { session in
            // TODO: store session maybe
            return api.rentals()
        }
        .future
        .onSuccess { rentals in
            BookRentalManager.rentals = rentals
            handler(rentals)
        }
    }
    
    func getUsername() -> String {
        return UserDefaults.standard.value(forKey: "username") as? String ?? ""
    }
    
    func getPassword() -> String {
        return KeychainWrapper().myObject(forKey: "v_Data") as? String ?? ""
    }
}
