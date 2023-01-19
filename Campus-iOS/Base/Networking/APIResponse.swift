//
//  APIResponse.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 2/27/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import Foundation
import FirebaseCrashlytics

struct APIResponse<ResponseType: Decodable, ErrorType: APIError>: Decodable {
    var response: ResponseType
    
    init(from decoder: Decoder) throws {
        if let error = try? ErrorType(from: decoder) {
            throw error
        } else {
            let response = try ResponseType(from: decoder)
            self.response = response
        }
    }
}

struct TUMOnlineAPIResponse<T: Decodable>: Decodable {
    var rows: [T]?

    enum CodingKeys: String, CodingKey {
        case rows = "row"
    }

    init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      self.rows = try container.decode([Throwable<T>].self, forKey: .rows).compactMap {
        do {
          return try $0.result.get()
        }
        catch {
          Crashlytics.crashlytics().record(error: error)
          return nil
        }
      }
    }
}

struct Throwable<T: Decodable>: Decodable {
  let result: Result<T, Error>

  init(from decoder: Decoder) throws {
    result = Result(catching: { try T(from: decoder) })
  }
}


