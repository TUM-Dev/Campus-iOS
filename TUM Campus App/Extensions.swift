//
//  Extensions.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 12/30/18.
//  Copyright © 2018 TUM. All rights reserved.
//

import Foundation
import SWXMLHash
import Alamofire
import CoreLocation
import UIKit

extension Bundle {
    var version: String { infoDictionary?["CFBundleShortVersionString"] as? String ?? "1" }
    var build: String { infoDictionary?["CFBundleVersion"] as? String ?? "1.0" }
    var userAgent: String { "TCA iOS \(version)/\(build)" }
}

enum BackendError: Error {
    case network(error: Error)
    case dataSerialization(error: Error)
    case jsonSerialization(error: Error)
    case xmlSerialization(error: Error)
    case objectSerialization(reason: String)
}

final class XMLSerializer: ResponseSerializer {
    let dataPreprocessor: DataPreprocessor
    let emptyResponseCodes: Set<Int>
    let emptyRequestMethods: Set<HTTPMethod>
    let config: (SWXMLHashOptions) -> Void

    public init(dataPreprocessor: DataPreprocessor = JSONResponseSerializer.defaultDataPreprocessor,
                emptyResponseCodes: Set<Int> = JSONResponseSerializer.defaultEmptyResponseCodes,
                emptyRequestMethods: Set<HTTPMethod> = JSONResponseSerializer.defaultEmptyRequestMethods,
                config: @escaping (SWXMLHashOptions) -> Void = { config in config.detectParsingErrors = true }) {
        self.dataPreprocessor = dataPreprocessor
        self.emptyResponseCodes = emptyResponseCodes
        self.emptyRequestMethods = emptyRequestMethods
        self.config = config
    }

    func serialize(request: URLRequest?, response: HTTPURLResponse?, data: Data?, error: Error?) throws -> XMLIndexer {
        let result = try DataResponseSerializer().serialize(request: request, response: response, data: data, error: error)
        let xmlParser = SWXMLHash.config(config)
        let xml = xmlParser.parse(result)

        switch xml {
        case let .xmlError(error):
            throw BackendError.xmlSerialization(error: error)
        default:
            return xml
        }
    }
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

extension UIColor {
    static let tumBlue = UIColor(red: 0, green: 101/255, blue: 189/255, alpha: 1)
}

extension UIButton {
    /// Animate a button, adding effect of "something went wrong". Useful for login button for example.
    func wiggle() {
        let feedbackGenerator = UINotificationFeedbackGenerator()
        let wiggleAnim = CABasicAnimation(keyPath: #keyPath(UIButton.layer.position))
        wiggleAnim.duration = 0.05
        wiggleAnim.repeatCount = 5
        wiggleAnim.autoreverses = true
        wiggleAnim.fromValue = CGPoint(x: self.center.x - 4.0, y: self.center.y)
        wiggleAnim.toValue = CGPoint(x: self.center.x + 4.0, y: self.center.y)
        layer.add(wiggleAnim, forKey: #keyPath(UIButton.layer.position))
        feedbackGenerator.notificationOccurred(.error)
    }
}

var appDelegate: AppDelegate {
    return UIApplication.shared.delegate as! AppDelegate
}

extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "context")!
}

extension DateFormatter {
    /// yyyy-MM-dd HH:mm:ss
    static let yyyyMMddhhmmss: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    /// "yyyy-MM-dd"
    static let yyyyMMdd: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}

extension Session {
    static var defaultSession: Session {
        let adapterAndRetrier = Interceptor(adapter: AuthenticationHandler(delegate: nil), retrier: AuthenticationHandler(delegate: nil))
        let trustManager = ServerTrustManager(evaluators: TUMCabeAPI.serverTrustPolicies)
        let manager = Session(interceptor: adapterAndRetrier, redirectHandler: ForceHTTPSRedirectHandler())
        return manager
    }
    
    static func defaultSession(authenticationHandlerDelegate delegate: AuthenticationHandlerDelegate) -> Session {
        let adapterAndRetrier = Interceptor(adapter: AuthenticationHandler(delegate: delegate), retrier: AuthenticationHandler(delegate: delegate))
        let trustManager = ServerTrustManager(evaluators: TUMCabeAPI.serverTrustPolicies)
        let manager = Session(interceptor: adapterAndRetrier, redirectHandler: ForceHTTPSRedirectHandler())
        return manager
    }
}

extension UITableViewController {
    func setBackgroundLabel(with text: String) {
        let noDataLabel = UILabel()
        noDataLabel.text = text
        noDataLabel.numberOfLines = 0
        noDataLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        noDataLabel.textColor = .systemGray
        noDataLabel.textAlignment = .center
        tableView.backgroundView = noDataLabel
    }
}

extension UICollectionView {
    func setBackgroundLabel(with text: String) {
        let noDataLabel = UILabel()
        noDataLabel.text = text
        noDataLabel.numberOfLines = 0
        noDataLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        noDataLabel.textColor = .systemGray
        noDataLabel.textAlignment = .center
        backgroundView = noDataLabel
    }
}


 extension KeyPath where Root: NSObject {
    var stringValue: String {
        return NSExpression(forKeyPath: self).keyPath
    }
}

extension UIView {
    static var nibName: String {  description().components(separatedBy: ".").last ?? "" }
    static var identifier: String { nibName }

    func fillSuperview(padding: UIEdgeInsets = .zero) {
        guard let superview = self.superview else {
            fatalError("Error! `superview` was nil – call `addSubview(view: UIView)` before calling `pinToSuperView()` to fix this.")
        }
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: superview.topAnchor, constant: 0).isActive = true
        self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: 0).isActive = true
        self.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: 0).isActive = true
        self.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: 0).isActive = true
    }
}

extension CLLocationCoordinate2D  {
    var location: CLLocation { CLLocation(latitude: latitude, longitude: longitude) }
}


extension Date {
    var calendar: Calendar { Calendar(identifier: Calendar.current.identifier) }
    var weekOfYear: Int { calendar.component(.weekOfYear, from: self) }
    var weekOfMonth: Int { calendar.component(.weekOfMonth, from: self) }

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
}


extension UITableViewCell {
    static var reuseIdentifier: String { NSStringFromClass(self).components(separatedBy: ".").last! }
}

extension UICollectionViewCell {
    static var reuseIdentifier: String { NSStringFromClass(self).components(separatedBy: ".").last! }
}

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
