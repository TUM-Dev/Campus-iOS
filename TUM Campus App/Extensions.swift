//
//  Extensions.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 7/21/16.
//  Copyright © 2016 LS1 TUM. All rights reserved.
//

import Foundation
import Sweeft

extension Date {
    
    func numberOfDaysUntilDateTime(_ toDateTime: Date, inTimeZone timeZone: TimeZone? = nil) -> Int {
        var calendar = Calendar.current
        if let timeZone = timeZone {
            calendar.timeZone = timeZone
        }
        
        let difference = calendar.dateComponents(Set([.day]), from: self, to: toDateTime)
        return difference.day ?? 0
    }
    
}


extension Collection {
    
    func mapped<V>() -> [V] {
        return flatMap { $0 as? V }
    }
    
}

extension Promise {
    
    func finish(with result: Result?, onNil error: ErrorType) {
        if let result = result {
            success(with: result)
        } else {
            self.error(with: error)
        }
    }
    
}

extension Bundle {
    
    var version: String {
        return infoDictionary?["CFBundleVersion"] as? String ?? "1.0"
    }
    
}
