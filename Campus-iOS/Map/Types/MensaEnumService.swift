//
//  MensaEnumService.swift
//  Campus-iOS
//
//  Created by August Wittgenstein on 14.01.22.
//

import Foundation
import Alamofire

final class MensaEnumService {
    static let shared = MensaEnumService()
    private var labels: [String : DishLabel]?

    public func getLabels() -> [String : DishLabel] {
     if self.labels == nil {
         self.labels = [:]
         AF.request(EatAPI.labels).responseDecodable(of: [DishLabel].self) { (response) in
             let labels = response.value ?? []
             for label in labels{
                 self.labels?[label.name] = label
             }
         }
     }

     return self.labels!
    }
}
