//
//  Extensions.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 7/21/16.
//  Copyright © 2016 LS1 TUM. All rights reserved.
//

import CoreLocation
import Sweeft

let locationManager = CLLocationManager()

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


extension SimpleManager {
    
    var location: CLLocation? {
        locationManager.startUpdatingLocation()
        let location = locationManager.location
        locationManager.stopUpdatingLocation()
        return location
    }
    
}

extension Collection {
    
    func mapped<V>() -> [V] {
        return flatMap { $0 as? V }
    }
    
    func sorted(byLocation path: KeyPath<Element, CLLocation>) -> [Element] {
        locationManager.startUpdatingLocation()
        let location = locationManager.location
        locationManager.stopUpdatingLocation()
        return location.map { location in
            return self.sorted(ascending: { location.distance(from: $0[keyPath: path]) })
        } ?? Array(self)
    }
    
}

extension Bundle {
    
    var version: String {
        return infoDictionary?["CFBundleVersion"] as? String ?? "1.0"
    }
    
}

extension Promise {
    
    @discardableResult func onSuccess(in queue: DispatchQueue, call handler: @escaping (T) -> ()) -> Promise<T, E> {
        let promise = map(completionQueue: queue) { $0 as T }
        promise.onSuccess(call: handler)
        return self
    }
    
    @discardableResult func onError(queue: DispatchQueue, call handler: @escaping (E) -> ()) -> Promise<T, E> {
        let promise = map(completionQueue: queue) { $0 as T }
        promise.onError(call: handler)
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
