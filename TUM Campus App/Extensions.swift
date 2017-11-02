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

private let locationManager = CLLocationManager()

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
        return infoDictionary?["CFBundleVersion"] as? String ?? "1.0"
    }
    
}

extension Promise {
    
    func mapError(to defaultValue: T) -> Promise<T, E> {
        return map { Result.value($0.value ?? defaultValue) }
    }
    
    @discardableResult func onSuccess(in queue: DispatchQueue, call handler: @escaping (T) -> ()) -> Promise<T, E> {
        let promise = map(completionQueue: queue) { $0 as T }
        promise.onSuccess(call: handler)
        return self
    }
    
    @discardableResult func onError(in queue: DispatchQueue, call handler: @escaping (E) -> ()) -> Promise<T, E> {
        let promise = map(completionQueue: queue) { $0 as T }
        promise.onError(call: handler)
        return self
    }
    
    @discardableResult func onResult(in queue: DispatchQueue, call handler: @escaping (Result) -> ()) -> Promise<T, E> {
        let promise = map(completionQueue: queue) { $0 as T }
        promise.onResult(call: handler)
        return self
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
        switch hex.characters.count {
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
