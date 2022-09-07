//
//  DataRepository.swift
//  HeatmapUIKit
//
//  Created by Kamber Vogli on 16.05.22.
//

import Foundation
import GRPC
import Logging
import SwiftProtobuf

class DataRepository {
  static let shared = DataRepository()
  private var apClient: Api_APServiceClient?
  
  private init() {
    let eventLoopGroup = PlatformSupport.makeEventLoopGroup(loopCount: 1)
    var logger = Logger(label: "gRPC", factory: StreamLogHandler.standardError(label:))
    logger.logLevel = .debug
    
    let channel = ClientConnection
      .insecure(group: eventLoopGroup)
      .connect(host: "backend.tca.uwpx.org", port: 50053)
    
    let callOptions = CallOptions(logger: logger)
    
    apClient = Api_APServiceClient(channel: channel, defaultCallOptions: callOptions)
    print("Connected to gRPC server")
  }
  
  func getAccessPointByName(_ name: String, timestamp: String) {
    var request = Api_APRequest()
    request.name = name
    request.timestamp = timestamp
    let result = apClient?.getAccessPoint(request, callOptions: .none)
    result?.response.whenComplete({ res in
      do {
        let reply = try res.get()
        print(reply.debugDescription)
      } catch {
        print("Could not get the access point with name \(name)!")
      }
    })
  }
  
  func getAPs(timestamp: String) -> [Api_AccessPoint] {
    var request = Api_APRequest()
    request.name = ""
    request.timestamp = timestamp
    var apList: [Api_AccessPoint] = []
    let result = apClient?.listAccessPoints(request, callOptions: .none, handler: { api_AccessPoint in
      apList.append(api_AccessPoint.accesspoint)
    })
    do {
      _ = try result?.status.wait()
    } catch {
      print("Could not get the list of access points!")
    }
    return apList
  }
  
}
