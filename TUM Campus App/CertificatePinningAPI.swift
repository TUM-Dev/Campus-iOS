//
//  SSLPinnedAPI.swift
//  Campus
//
//  Created by Mathias Quintero on 2/13/18.
//  Copyright © 2018 LS1 TUM. All rights reserved.
//

import Sweeft
import Security

/// Validate that the trust isn't expired or anything
private func validate(trust: SecTrust) -> Bool {
    var secResult: SecTrustResultType = .invalid
    guard SecTrustEvaluate(trust, &secResult) == errSecSuccess else {
        return false
    }
    return secResult == .proceed || secResult == .unspecified
}

/// Validate that the trust isn't expired or anything and that it corresponds to the host
private func validate(trust: SecTrust, for host: String) -> Bool {
    
    let policy = SecPolicyCreateSSL(true, host as CFString)

    guard SecTrustSetPolicies(trust, [policy] as CFArray) == errSecSuccess else {
        return false
    }
    return validate(trust: trust)
}

/// Data objects for the individual certificats in trust
private func certificates(trust: SecTrust) -> [Data]? {
    let certificateCount = SecTrustGetCertificateCount(trust)
    guard certificateCount > 0 else {
        return nil
    }
    let certificates = (0..<certificateCount).flatMap { SecTrustGetCertificateAtIndex(trust, $0) }
    let data = certificates.map { SecCertificateCopyData($0) as Data }
    return data
}

/// SHA256 Hash of the Data of the individual certificats in trust
private func certificateSHA256Fingerprints(trust: SecTrust) -> [String]? {
    return certificates(trust: trust).map { $0.map { $0.sha256 } }
}

extension Data {
    
    fileprivate var sha256: String {
        
        // Ugh! Had to includ common crypto in the Bridging Header for this...
        // This whole thing is a horrible, horrible hack so I don't have to write C...
        // I hate writing C. I suppose it's because when I have to write C it's
        // because of sh*t like this. Oh well ¯\_(ツ)_/¯
        
        let data = self as NSData
        let dataPointer = data.bytes
        
        let digestLength = Int(CC_SHA256_DIGEST_LENGTH)
        let finalPointer = UnsafeMutablePointer<UInt8>.allocate(capacity: digestLength)
        
        CC_SHA256(dataPointer, CC_LONG(data.length), finalPointer)
        
        let buffer = UnsafeBufferPointer<UInt8>(start: finalPointer, count: digestLength)
        let parsed = Data(buffer: buffer)
        
        return parsed.reduce("") { string, byte in
            return string.appendingFormat("%02X", byte)
        }
        
    }
    
}

/// Has to be a class because urlSession Delegate methods protocol to be an @objc protocol
class CertificatePinningAPI<EndpointType: APIEndpoint>: NSObject, CustomAPI {
    
    typealias Endpoint = EndpointType
    
    var baseHeaders: [String : String] { return .empty }
    var baseQueries: [String : String] { return .empty }
    
    let baseURL: String
    let sha256Fingerprints: [String]
    
    init(baseURL: String, sha256Fingerprints: [String]) {
        self.baseURL = baseURL
        self.sha256Fingerprints = sha256Fingerprints
    }
    
    func urlSession(_ session: URLSession,
                    didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        let fingerprints = Set(sha256Fingerprints.map { $0.uppercased().replacingOccurrences(of: " ", with: "") })
        
        guard challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust,
            let trust = challenge.protectionSpace.serverTrust,
            let host = base.host,
            validate(trust: trust, for: host),
            let certificates = certificateSHA256Fingerprints(trust: trust),
            fingerprints.isSubset(of: certificates) else {
                
            return completionHandler(.cancelAuthenticationChallenge, nil)
        }
        
        completionHandler(.useCredential, URLCredential(trust: trust))
    }
    
}
