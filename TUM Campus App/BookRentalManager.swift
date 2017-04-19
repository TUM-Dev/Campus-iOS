//
//  File.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 19.04.17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import Foundation
import Alamofire
import Kanna

class BookRentalManager: Manager {
    
    var main: TumDataManager
    
    var handler: (([DataElement]) -> ())?
    
    required init(mainManager: TumDataManager) {
        main = mainManager
    }

    func fetchData(_ handler: @escaping ([DataElement]) -> ()) {
        <#code#>
    }
}
