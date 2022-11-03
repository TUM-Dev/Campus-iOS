//
//  Array+Groups.swift
//  Campus-iOS
//
//  Created by Robyn Kölle on 27.09.22.
//

import Foundation

extension Array {
    func groups(where predicate: (Element, Element) -> Bool, minGroupSize: Int = 1) -> [[Element]] {
        
        var result: [[Element]] = []
        
        if self.isEmpty {
            return []
        }
        
        for i in 0..<self.count {
            
            var group: [Element] = [self[i]]
            
            for j in 0..<self.count {
                if i == j { continue }
                if (!predicate(self[i], self[j])) { continue }
                group.append(self[j])
            }
            
            if group.count >= minGroupSize {
                result.append(group)
            }
        }
        
        return result
    }
}
