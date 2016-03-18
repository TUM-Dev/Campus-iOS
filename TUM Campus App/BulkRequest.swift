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

    init(receiver: TumDataReceiver) {
        self.receiver = receiver
    }
    
    var data = [DataElement]()
    
    func receiveData(data: [DataElement]) {
        self.data.appendContentsOf(data)
        receiver?.receiveData(self.data)
    }
    
}