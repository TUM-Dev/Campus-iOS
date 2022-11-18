//
//  TokenPermissionsViewModel+PermissionType.swift
//  Campus-iOS
//
//  Created by David Lin on 17.10.22.
//

import Foundation

extension TokenPermissionsViewModel {
    enum PermissionType: String {
        case grades = "Grades"
        case calendar = "Calendar"
        case lectures = "Lectures"
        case tuitionFees = "Tuition Fees"
        case identification = "Identification (TUM ID and name)"
    }
}
