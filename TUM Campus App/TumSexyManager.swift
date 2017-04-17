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
        Alamofire.request("http://json.tum.sexy").responseJSON() { (response) in
            if let value = response.result.value {
                if let items = JSON(value).dictionary {
                    var links = [DataElement]()
                    for (key, value) in items {
                        if let text = value["description"].string, let link = value["target"].string {
                            links.append(SexyEntry(name: key, link: link, descriptionText: text))
                        }
                    }
                    handler(links)
                }
            }
        }
    }
    
}
