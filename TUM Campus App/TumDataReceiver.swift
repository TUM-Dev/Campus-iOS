//
//  TumDataReceiver.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/6/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Foundation
protocol TumDataReceiver {
    func receiveData(data: [DataElement])
}