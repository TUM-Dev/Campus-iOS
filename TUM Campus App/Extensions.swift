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
        let manager = Session(interceptor: adapterAndRetrier)
        return manager
    }
    
    static func defaultSession(authenticationHandlerDelegate delegate: AuthenticationHandlerDelegate) -> Session {
        let adapterAndRetrier = Interceptor(adapter: AuthenticationHandler(delegate: delegate), retrier: AuthenticationHandler(delegate: delegate))
        let trustManager = ServerTrustManager(evaluators: TUMCabeAPI.serverTrustPolicies)
        let manager = Session(interceptor: adapterAndRetrier)
        return manager
    }
}

extension NSMutableAttributedString {
    @discardableResult func bold(_ text: String, color: UIColor = .black) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont(name: "AvenirNext-Bold", size: 12)!, .foregroundColor: color]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        append(boldString)
        
        return self
    }
    
    @discardableResult func normal(_ text: String, color: UIColor = .black) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont(name: "AvenirNext-Medium", size: 12)!, .foregroundColor: color]
        let normal = NSAttributedString(string: text, attributes: attrs)
        append(normal)
        
        return self
    }
    
    var newLine: NSMutableAttributedString {
        let newLine = NSAttributedString(string: "\n")
        append(newLine)
        
        return self
    }
}

extension UITableViewController {
    func setBackgroundLabel(with text: String) {
        let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        noDataLabel.text = text
        noDataLabel.font = UIFont.systemFont(ofSize: 24)
        noDataLabel.textColor = .gray
        noDataLabel.textAlignment = .center
        tableView.backgroundView = noDataLabel
        tableView.separatorStyle = .none
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
        translatesAutoresizingMaskIntoConstraints = false
        if let superviewTopAnchor = superview?.topAnchor {
            topAnchor.constraint(equalTo: superviewTopAnchor, constant: padding.top).isActive = true
        }

        if let superviewBottomAnchor = superview?.bottomAnchor {
            bottomAnchor.constraint(equalTo: superviewBottomAnchor, constant: -padding.bottom).isActive = true
        }

        if let superviewLeadingAnchor = superview?.leadingAnchor {
            leadingAnchor.constraint(equalTo: superviewLeadingAnchor, constant: padding.left).isActive = true
        }

        if let superviewTrailingAnchor = superview?.trailingAnchor {
            trailingAnchor.constraint(equalTo: superviewTrailingAnchor, constant: -padding.right).isActive = true
        }
    }
}

extension CLLocationCoordinate2D  {
    var location: CLLocation { CLLocation(latitude: latitude, longitude: longitude) }
}


extension Date {

    var calendar: Calendar {
        return Calendar(identifier: Calendar.current.identifier) // Workaround to segfault on corelibs foundation https://bugs.swift.org/browse/SR-10147
    }

    var weekOfYear: Int {
        return calendar.component(.weekOfYear, from: self)
    }

    var weekOfMonth: Int {
        return calendar.component(.weekOfMonth, from: self)
    }

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
