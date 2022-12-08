//
//  Theme.swift
//  Campus-iOS
//
//  Created by Timothy Summers on 08.11.22.
//

import Foundation
import SwiftUI

extension Color {
    static let tumBrand = Color("tumBrand")
    static let primaryBackground = Color("primaryBackground")
    static let secondaryBackground = Color("secondaryBackground")
    static let primaryText = Color("primaryText")
    static let contrastText = Color("contrastText")
    static var tumBlue = Color("tumBlue")
    static var widget = Color("widgetColor")
}

extension UIColor {
    static let tumBlue = UIColor(red: 0, green: 101/255, blue: 189/255, alpha: 1)
    static let primaryBackground = UIColor(Color("primaryBackground"))
    static let secondaryBackground = UIColor(Color("secondaryBackground"))
    static let primaryText = UIColor(Color("primaryText"))
    static let contrastText = UIColor(Color("contrastText"))
}
   
extension Font {
    static let body = Font.custom("Roboto", size: 12)
    static let test = Font.custom("Roboto", size: 12)
}



