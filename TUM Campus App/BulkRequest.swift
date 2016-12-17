//
//  BulkRequest.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/6/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Foundation

class BulkRequest: TumDataReceiver {
    
    var receiver: TumDataReceiver?
    let sorter: DataSorter?
    
    typealias DataSorter = (DataElement) -> (Int)

    init(receiver: TumDataReceiver, sorter: DataSorter? = nil) {
        self.receiver = receiver
        self.sorter = sorter
    }
    
    var data = [DataElement]()
    
    func receiveData(_ data: [DataElement]) {
        self.data.append(contentsOf: data)
        if let sorter = sorter {
            self.data.sort {
                return sorter($0) < sorter($1)
            }
        }
        receiver?.receiveData(self.data)
    }
    
}
