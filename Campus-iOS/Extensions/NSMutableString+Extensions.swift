//
//  NSMutableString+Extensions.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 09.02.22.
//

import Foundation
import UIKit

extension NSMutableAttributedString {

    fileprivate var range: NSRange {
        return NSRange(location: 0, length: length)
    }

    fileprivate var paragraphStyle: NSMutableParagraphStyle? {
        return attributes(at: 0, effectiveRange: nil)[NSAttributedString.Key.paragraphStyle] as? NSMutableParagraphStyle
    }

}

// MARK: - Font
extension NSMutableAttributedString {
    /**
     Applies a font to the entire string.

     - parameter font: The font.
     */
    @discardableResult
    public func font(_ font: UIFont) -> Self {
        addAttribute(NSAttributedString.Key.font, value: font, range: range)
        return self
    }

    /**
     Applies a font to the entire string.

     - parameter name: The font name.
     - parameter size: The font size.

     Note: If the specified font name cannot be loaded, this method will fallback to the system font at the specified size.
     */
    @discardableResult
    public func font(name: String, size: CGFloat) -> Self {
        addAttribute(NSAttributedString.Key.font, value: UIFont(name: name, size: size) ?? .systemFont(ofSize: size), range: range)
        return self
    }
}

extension NSMutableAttributedString {
    /**
     Applies the given color over the entire string, as the foreground color.

     - parameter color: The color to apply.
     */
    @discardableResult @nonobjc
    public func color(_ color: UIColor, alpha: CGFloat = 1) -> Self {
        addAttribute(NSAttributedString.Key.foregroundColor, value: color.withAlphaComponent(alpha), range: range)
        return self
    }

    /**
     Applies the given color over the entire string, as the foreground color.

     - parameter color: The color to apply.
     */
    @discardableResult
    public func color(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1) -> Self {
        addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red: red, green: green, blue: blue, alpha: alpha), range: range)
        return self
    }

    /**
     Applies the given color over the entire string, as the foreground color.

     - parameter color: The color to apply.
     */
    @discardableResult
    public func color(white: CGFloat, alpha: CGFloat = 1) -> Self {
        addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(white: white, alpha: alpha), range: range)
        return self
    }

    /**
     Applies the given color over the entire string, as the foreground color.

     - parameter color: The color to apply.
     */
    @discardableResult @nonobjc
    public func color(_ hex: UInt32, alpha: CGFloat = 1) -> Self {
        addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(white: CGFloat(hex), alpha: alpha), range: range)
        return self
    }
}
