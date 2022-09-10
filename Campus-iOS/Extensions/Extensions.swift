//
//  Extensions.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 15.12.21.
//

import Foundation
import Alamofire
import CoreLocation
import SWXMLHash
import XMLCoder
import SwiftUI

extension Bundle {
    var version: String { infoDictionary?["CFBundleShortVersionString"] as? String ?? "1" }
    var build: String { infoDictionary?["CFBundleVersion"] as? String ?? "1.0" }
    var userAgent: String { "TCA iOS \(version)/\(build)" }
}

extension Session {
    static let defaultSession: Session = {
        let adapterAndRetrier = Interceptor(adapter: AuthenticationHandler(), retrier: AuthenticationHandler())
        let cacher = ResponseCacher(behavior: .cache)
//        let trustManager = ServerTrustManager(evaluators: TUMCabeAPI.serverTrustPolicies)
        let manager = Session(interceptor: adapterAndRetrier, redirectHandler: ForceHTTPSRedirectHandler(), cachedResponseHandler: cacher)
        return manager
    }()
}

extension DataRequest {
    @discardableResult
    public func responseXML(queue: DispatchQueue = .main,
                             completionHandler: @escaping (AFDataResponse<XMLIndexer>) -> Void) -> Self {

        response(queue: queue,
                 responseSerializer: XMLSerializer(),
                 completionHandler: completionHandler)
    }
}

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}

extension Date {
    var calendar: Calendar { Calendar(identifier: Calendar.current.identifier) }
    var weekOfMonth: Int { calendar.component(.weekOfMonth, from: self) }
    
    var isoCalendar: Calendar { Calendar(identifier: .iso8601) }
    var weekOfYear: Int { isoCalendar.component(.weekOfYear, from: self) }

    var year: Int {
        get {
            return calendar.component(.year, from: self)
        }
        set {
            guard newValue > 0 else { return }
            let currentYear = calendar.component(.year, from: self)
            let yearsToAdd = newValue - currentYear
            if let date = calendar.date(byAdding: .year, value: yearsToAdd, to: self) {
                self = date
            }
        }
    }

    var month: Int {
        get {
            return calendar.component(.month, from: self)
        }
        set {
            let allowedRange = calendar.range(of: .month, in: .year, for: self)!
            guard allowedRange.contains(newValue) else { return }

            let currentMonth = calendar.component(.month, from: self)
            let monthsToAdd = newValue - currentMonth
            if let date = calendar.date(byAdding: .month, value: monthsToAdd, to: self) {
                self = date
            }
        }
    }

    var day: Int {
        get {
            return calendar.component(.day, from: self)
        }
        set {
            let allowedRange = calendar.range(of: .day, in: .month, for: self)!
            guard allowedRange.contains(newValue) else { return }

            let currentDay = calendar.component(.day, from: self)
            let daysToAdd = newValue - currentDay
            if let date = calendar.date(byAdding: .day, value: daysToAdd, to: self) {
                self = date
            }
        }
    }

    func isLaterThanOrEqual(to date: Date) -> Bool {
        return self.compare(date) == .orderedDescending || self.compare(date) == .orderedSame
    }

    /// Determine if date is within the current day
    var isToday: Bool {
        let calendar = Calendar.autoupdatingCurrent
        return calendar.isDateInToday(self)
    }

    /// Determine if date is within the day tomorrow
    var isTomorrow: Bool {
        let calendar = Calendar.autoupdatingCurrent
        return calendar.isDateInTomorrow(self)
    }
}

extension DateFormatter {
    /// yyyy-MM-dd HH:mm:ss
    static let yyyyMMddhhmmss: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "Europe/Berlin")!
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    /// "yyyy-MM-dd"
    static let yyyyMMdd: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "Europe/Berlin")!
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    /// "EEEE, dd. MMM"
    static let EEEEddMMM: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "Europe/Berlin")!
        formatter.dateFormat = "EEEE, dd. MMM"
        return formatter
    }()
}

extension CLLocationCoordinate2D  {
    var location: CLLocation { CLLocation(latitude: latitude, longitude: longitude) }
}

extension UIColor {
    static let tumBlue = UIColor(red: 0, green: 101/255, blue: 189/255, alpha: 1)
}

extension Color {
    
    static var tumBlue = Color("tumBlue")
    
    static var widget = Color("widgetColor")
}

extension JSONDecoder.DateDecodingStrategy: DecodingStrategyProtocol { }

extension XMLDecoder.DateDecodingStrategy: DecodingStrategyProtocol { }

extension JSONDecoder: DecoderProtocol {
    static var contentType: [String] { return ["application/json"] }
    static func instantiate() -> Self {
        //  infers the type of self from the calling context:
        func helper<T>() -> T {
            let decoder = JSONDecoder()
            return decoder as! T
        }
        return helper()
    }
}

extension XMLDecoder: DecoderProtocol {
    static var contentType: [String] { return ["text/xml"] }
    static func instantiate() -> Self {
        // infers the type of self from the calling context
        func helper<T>() -> T {
            let decoder = XMLDecoder()
            return decoder as! T
        }
        return helper()
    }
}

extension View {
    /// Applies the given transform according to condition.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transformT: The transform to apply to the source `View` if condition is true.
    ///   - transformF: The transform to apply to the source `View` if condition is false.
    /// - Returns: Modified `View` based on condition.
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transformT: (Self) -> Content, transformF: ((Self) -> Content)? = nil) -> some View {
        if condition {
            transformT(self)
        } else if let transform = transformF {
            transform(self)
        } else {
            self
        }
    }
}

extension UIColor {
    
    @available(iOS 13, *)
    static func useForStyle(dark: UIColor, white: UIColor) -> UIColor {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            return traitCollection.userInterfaceStyle == .dark ? dark : white
        }
    }
}

extension String: Identifiable {
    public typealias ID = Int
    public var id: Int {
        return hash
    }
}

// For the NewsView: In order to show the right link when using the WebView when tapping on a NewsCard
extension URL: Identifiable {
    public var id: UUID { UUID() }
}
