//
//  AccountType.swift
//  Campus
//
//  Created by Mathias Quintero on 1/25/18.
//  Copyright © 2018 LS1 TUM. All rights reserved.
//

import Sweeft

enum AccountType: Int, Codable {
    case student
    case employee
    case alumni
}

extension AccountType {
    
    var key: String {
        switch self {
        case .student:
            return "studierende"
        case .employee:
            return "bedienstete"
        case .alumni:
            return "extern"
        }
    }
    
}

struct CurrentAccountType: SingleStatus {
    static var key: AppDefaults = .accountType
    static var defaultValue: AccountType = .student
}
