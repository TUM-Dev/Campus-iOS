//
//  MensaEnumService.swift
//  TUMCampusApp
//
//  Created by Philipp Wenner on 12.01.22.
//  Copyright © 2022 TUM. All rights reserved.
//

import Foundation
import Alamofire

final class MensaEnumService {
    static let shared = MensaEnumService()
    private var labels: [String:Label]?
    
    public func getLabels() -> [String:Label] {
        if self.labels == nil {
            self.labels = [:]
            AF.request(EatAPI.labels).responseDecodable(of: [Label].self) { (response) in
                let labels = response.value ?? []
                for label in labels{
                    self.labels?[label.name] = label
                }
            }
        }
        
        return self.labels!
    }
}
