//
//  CampusBackend.swift
//  Campus-iOS
//
//  Created by Anton Wyrowski on 29.11.22.
//

import Foundation
import GRPC

struct CampusBackend {
    
    private static let s = CampusBackend()
    
    static let shared = s.client
    
    let client: Api_CampusAsyncClient
    
    private init() {
        let group = PlatformSupport.makeEventLoopGroup(loopCount: 1)
     
        do {
            let channel = try GRPCChannelPool.with(
              target: .host("localhost", port: 50051),
              transportSecurity: .plaintext,
              eventLoopGroup: group
            )
            
            client = Api_CampusAsyncClient(channel: channel)
        } catch {
            fatalError("Couldn't start campus backend client!")
        }
    }
}
