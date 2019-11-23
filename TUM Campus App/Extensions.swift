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

extension DataRequest {
    static func xmlResponseSerializer() -> DataResponseSerializer<XMLIndexer> {
        return DataResponseSerializer { (_, response, data, error) -> Result<XMLIndexer> in
            
            if let error = error {
                return .failure(error)
            }
            
            let result = Request.serializeResponseData(response: response, data: data, error: nil)
            
            guard case let .success(validData) = result else {
                return .failure(BackendError.dataSerialization(error: result.error! as! AFError))
            }
            
            let xmlParser = SWXMLHash.config { config in config.detectParsingErrors = true }
            let xml = xmlParser.parse(validData)
            
            switch xml {
            case let .xmlError(error):
                return .failure(BackendError.xmlSerialization(error: error))
            default:
                return .success(xml)
            }
        }
    }
    
    @discardableResult
    func responseXML(
        queue: DispatchQueue? = nil,
        completionHandler: @escaping (DataResponse<XMLIndexer>) -> Void)
        -> Self
    {
        return response(
            queue: queue,
            responseSerializer: DataRequest.xmlResponseSerializer(),
            completionHandler: completionHandler
        )
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

extension UIViewController {
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
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

extension SessionManager {
    static var defaultSessionManager: SessionManager {
        let manager = SessionManager(serverTrustPolicyManager: ServerTrustPolicyManager(policies: TUMCabeAPI.serverTrustPolicies))
        manager.adapter = AuthenticationHandler(delegate: nil)
        manager.retrier = AuthenticationHandler(delegate: nil)
        return manager
    }
    
    static func defaultSessionManager(authenticationHandlerDelegate delegate: AuthenticationHandlerDelegate) -> SessionManager {
        let manager = SessionManager(serverTrustPolicyManager: ServerTrustPolicyManager(policies: TUMCabeAPI.serverTrustPolicies))
        manager.adapter = AuthenticationHandler(delegate: delegate)
        manager.retrier = AuthenticationHandler(delegate: delegate)
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

extension UITableViewController{
    func SetBackgroundLabel(with text : String){
        let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        noDataLabel.text          = text
        noDataLabel.font = UIFont.systemFont(ofSize: 24)
        noDataLabel.textColor     = UIColor.gray
        noDataLabel.textAlignment = .center
        tableView.backgroundView  = noDataLabel
        tableView.separatorStyle  = .none

 extension KeyPath where Root: NSObject {
    var stringValue: String {
        return NSExpression(forKeyPath: self).keyPath
    }
}
