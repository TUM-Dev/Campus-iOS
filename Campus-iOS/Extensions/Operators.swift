//
//  Operators.swift
//  Campus-iOS
//
//  Created by Robyn Kölle on 07.09.22.
//

import Foundation
import SwiftUI

// Source: https://stackoverflow.com/a/61733134
prefix func ! (value: Binding<Bool>) -> Binding<Bool> {
    Binding<Bool>(
        get: { !value.wrappedValue },
        set: { value.wrappedValue = !$0 }
    )
}
