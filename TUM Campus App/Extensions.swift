//
//  Extensions.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 7/21/16.
//  Copyright © 2016 LS1 TUM. All rights reserved.
//

import CoreLocation
import UIKit
import SafariServices
import Sweeft

private var locationManager: CLLocationManager = Thread.isMainThread ? CLLocationManager() : DispatchQueue.main.sync { CLLocationManager() }

private func currentLocation() -> CLLocation {
    locationManager.startUpdatingLocation()
    let location = locationManager.location
    locationManager.stopUpdatingLocation()
    return location ?? DefaultCampus.value.location
}

extension URL {
    
    func open(sender: UIViewController? = nil) {
        if let sender = sender {
            let safariViewController = SFSafariViewController(url: self)
            sender.present(safariViewController, animated: true, completion: nil)
        } else {
            UIApplication.shared.open(self, options: [:], completionHandler: nil)
        }
    }
    
}

extension Date {
    
    var dayString: String {
        return string(using: "yyyy-MM-dd")
    }
    
    func numberOfDaysUntilDateTime(_ toDateTime: Date, inTimeZone timeZone: TimeZone? = nil) -> Int {
        var calendar = Calendar.current
        if let timeZone = timeZone {
            calendar.timeZone = timeZone
        }
        
        let difference = calendar.dateComponents(Set([.day]), from: self, to: toDateTime)
        return difference.day ?? 0
    }
    
}

extension SimpleManager {
    
    var location: CLLocation {
        return currentLocation()
    }
    
}

extension Array {
    
    func lastIndex(where criteria: (Element) throws -> Bool) rethrows -> Int? {
        return try enumerated().reduce(nil) { last, value in
            if try criteria(value.element) {
                return value.offset
            }
            return last
        }
    }
    
}

extension Collection {
    
    func mapped<V>() -> [V] {
        return flatMap { $0 as? V }
    }
    
    func first<V: Equatable>(where path: KeyPath<Element, V>, equals value: V) -> Element? {
        return first { $0[keyPath: path] == value }
    }
    
    func sorted(byLocation path: KeyPath<Element, CLLocation>) -> [Element] {
        let location = currentLocation()
        return self.sorted(ascending: { location.distance(from: $0[keyPath: path]) })
    }
    
    func grouped<V: Hashable>(by path: KeyPath<Element, V>) -> [V : [Element]] {
        return reduce([:]) { dict, element in
            var dict = dict
            let key = element[keyPath: path]
            dict[key, default: []].append(element)
            return dict
        }
    }
    
}

extension Bundle {
    
    var version: String {
        return infoDictionary?["CFBundleShortVersionString"] as? String ?? "1"
    }
    
    var build: String {
        return infoDictionary?["CFBundleVersion"] as? String ?? "1.0"
    }
    
    var userAgent: String {
        return "TCA iOS \(version)/\(build)"
    }
    
}

extension Promise {
    
    func mapError(to defaultValue: T) -> Promise<T, E> {
        return mapResult { .value($0.value ?? defaultValue) }
    }
    
}

extension TimeInterval {
    
    static var oneMinute: TimeInterval {
        return 60
    }
    
    static var oneHour: TimeInterval {
        return 60 * .oneMinute
    }
    
    static var sixHours: TimeInterval {
        return 6 * .oneHour
    }
    
    static var aboutOneDay: TimeInterval {
        return 24 * .oneHour
    }
    
    static var aboutOneWeek: TimeInterval {
        return 7 * .aboutOneDay
    }
    
}

extension UIViewController {
    func showError(_ title: String, _ message: String? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        
        present(alert, animated: true)
    }
}

extension Double {
    
    var bool: Bool {
        return NSNumber(value: self).boolValue
    }
    
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

extension API {
    
    func removeCache(for endpoint: Endpoint,
                     arguments: [String:CustomStringConvertible] = .empty,
                     queries: [String:CustomStringConvertible] = .empty) {
        
        .global() >>> {
            let url = self.url(for: endpoint, arguments: arguments, queries: queries)
            let cacheKey = url.relativePath.replacingOccurrences(of: "/", with: "_")
            self.cache.delete(at: cacheKey)
        }
    }
    
    func clearCache() {
        cache.clear()
    }
    
}

extension FileCache {
    
    private var searchPathURL: URL {
        let urls = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask)
        return urls[urls.count - 1].appendingPathComponent(directory)
    }
    
    func clear() {
        try? FileManager.default.removeItem(at: searchPathURL)
    }
    
}

extension CGContext {
    
    func addRoundedRectToPath(rect: CGRect, ovalWidth: CGFloat, ovalHeight: CGFloat) {
        if ovalWidth == 0 || ovalHeight == 0 {
            return self.addRect(rect)
        }
        saveGState()
        setStrokeColor(Constants.tumBlue.cgColor)
        translateBy(x: rect.minX, y: rect.minY)
        scaleBy(x: ovalWidth, y: ovalHeight)
        
        let relativeWidth = rect.width / ovalWidth
        let relativeHeight = rect.height / ovalHeight
        
        move(to: .init(x: relativeWidth, y: relativeHeight / 2))
        addArc(tangent1End: .init(x: relativeWidth, y: relativeHeight),
               tangent2End: .init(x: relativeWidth / 2, y: relativeHeight),
               radius: 1.0)
        addArc(tangent1End: .init(x: 0, y: relativeHeight),
               tangent2End: .init(x: 0, y: relativeHeight / 2),
               radius: 1.0)
        addArc(tangent1End: .init(x: 0, y: 0),
               tangent2End: .init(x: relativeWidth / 2, y: 0),
               radius: 1.0)
        addArc(tangent1End: .init(x: relativeWidth, y: 0),
               tangent2End: .init(x: relativeWidth, y: relativeHeight / 2),
               radius: 1.0)
        
        restoreGState()
    }
    
}

extension UIImage {
    
    func resized(to newSize: CGSize, scale: CGFloat = 0.0) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, scale)
        self.draw(in: .init(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? self
    }
    
    func withRoundedCorners(radius: CGFloat, borderSize: CGFloat) -> UIImage {
        let scale = max(self.scale, 1.0)
        let scaledBorderSize = scale * borderSize
        let scaledRadius = scale * radius
        
        guard let cgImage = self.cgImage,
            let colorSpace = cgImage.colorSpace else {
                
            return self
        }
        
        let width = size.width * scale
        let height = size.height * scale
        
        let context = CGContext.init(data: nil,
                                     width: Int(width),
                                     height: Int(height),
                                     bitsPerComponent: cgImage.bitsPerComponent,
                                     bytesPerRow: cgImage.bytesPerRow,
                                     space: colorSpace,
                                     bitmapInfo: cgImage.bitmapInfo.rawValue)
        
        context?.setFillColor(UIColor.white.cgColor)
        context?.fill(.init(x: 0, y: 0, width: width, height: height))
        context?.beginPath()
        let rect = CGRect(x: scaledBorderSize,
                          y: scaledBorderSize,
                          width: width - borderSize * 2,
                          height: height - borderSize * 2)
        context?.addRoundedRectToPath(rect: rect, ovalWidth: scaledRadius, ovalHeight: scaledRadius)
        context?.closePath()
        context?.clip()
        context?.draw(cgImage, in: .init(x: 0, y: 0, width: width, height: height))
        
        let ref = context?.makeImage()
        
        guard let image = ref.map({ UIImage(cgImage: $0, scale: scale, orientation: .up) }) else {
            return self
        }
        
        return image
    }
    
    func squared() -> UIImage {
        
        guard let cgImage = self.cgImage else {
            return self
        }
        
        let width = cgImage.width
        let height = cgImage.height
        let cropSize = min(width, height)
        
        let x = Double(width - cropSize) / 2.0
        let y = Double(height - cropSize) / 2.0
        
        let rect = CGRect(x: CGFloat(x),
                          y: CGFloat(y),
                          width: CGFloat(cropSize),
                          height: CGFloat(cropSize))
        
        let newImage = cgImage.cropping(to: rect) ?? cgImage
        
        return UIImage(cgImage: newImage,
                       scale: 0.0,
                       orientation: self.imageOrientation)
    }
    
}

extension JSON {
    
    var strings: [String] {
        return array ==> { $0.string }
    }
}

extension Collection {
    
    var nonEmpty: Self? {
        guard !isEmpty else { return nil }
        return self
    }
    
}
