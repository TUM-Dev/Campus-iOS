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
    
    let keychainWrapper = KeychainWrapper()
    var user = ""
    var password = ""
    let opac_url = "https://opac.ub.tum.de/InfoGuideClient.tumsis"
    
    
    var main: TumDataManager
    
    required init(mainManager: TumDataManager) {
        main = mainManager
        password = keychainWrapper.myObject(forKey: "v_Data") as? String ?? ""
        user = UserDefaults.standard.value(forKey: "username") as? String ?? ""
    }
    
    static var rentals = [DataElement]()


    func fetchData(_ handler: @escaping ([DataElement]) -> ()) {
        
        let api = BookRentalAPI(baseURL: opac_url)
        
        api.start().onSuccess { csid in
            return api.login(user: self.user, password: self.password, csid: csid)
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
}
