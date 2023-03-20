//
//  CampusBackend.swift
//  Campus-iOS
//
//  Created by Anton Wyrowski on 29.11.22.
//

import Foundation
import GRPC
import Logging

struct CampusBackend {
    
    private static let s = CampusBackend()
    
    static let shared = s.client
    
    let client: Api_CampusAsyncClient
    
    private init() {
        let group = PlatformSupport.makeEventLoopGroup(loopCount: 1)
     
        var logger = Logger(label: "gRPC", factory: StreamLogHandler.standardOutput(label:))
        logger.logLevel = .debug
        

        /* let channel = ClientConnection
              .usingPlatformAppropriateTLS(for: group)
              .withBackgroundActivityLogger(logger)
              .connect(host: "api-grpc.tum.app", port: 443)
        
        // For local development will be removed after
        // backend changes are merged
        let channel = ClientConnection
            .insecure(group: group)
            .withBackgroundActivityLogger(logger)
            .connect(host: "192.168.178.41", port: 50051)
        
        client = Api_CampusAsyncClient(channel: channel)
    }
}
