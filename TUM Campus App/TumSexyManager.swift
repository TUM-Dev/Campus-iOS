//
//  TumSexyManager.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 3/28/17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import Alamofire
import SwiftyJSON
import Sweeft

class TumSexyManager: Manager {
    
    required init(mainManager: TumDataManager) {
        // Nothing required
    }
    
    func fetchData(_ handler: @escaping ([DataElement]) -> ()) {
        Alamofire.request("http://json.tum.sexy").responseJSON { response in
            if let value = response.result.value,
                let items = JSON(value).dictionary {
                
                let links = items.flatMap(SexyEntry.init).map { $0 as DataElement }
                handler(links)
            }
        }
    }
    
}
