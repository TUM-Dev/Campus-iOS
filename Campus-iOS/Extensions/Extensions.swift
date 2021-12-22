//
//  Extensions.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 15.12.21.
//

import Foundation
import Alamofire
import SWXMLHash

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
