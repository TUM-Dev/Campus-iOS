//
//  MockReceiver.swift
//  TUM Campus App
//
//  Created by Max Muth on 06.03.17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import XCTest

@testable import Campus

class MockReceiver: TumDataReceiver {
    let mockReceiveData: (([DataElement], XCTestExpectation) -> Void)?
    let expectation: XCTestExpectation?
    
    init(receiveData: @escaping (([DataElement], XCTestExpectation) -> Void), expectation: XCTestExpectation) {
        self.mockReceiveData = receiveData
        self.expectation = expectation
    }
    
    func receiveData(_ data: [DataElement]) {
        self.mockReceiveData?(data, self.expectation!)
    }
}
