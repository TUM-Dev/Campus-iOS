//
//  PersistentUserData.swift
//  TUM Campus App
//
//  This file is part of the TUM Campus App distribution https://github.com/TCA-Team/iOS
//  Copyright (c) 2018 TCA
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, version 3.
//
//  This program is distributed in the hope that it will be useful, but
//  WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
//  General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program. If not, see <http://www.gnu.org/licenses/>.
//

import Sweeft

enum PersistendUserData: Codable {
    
    enum State: Int, Codable {
        case loggedIn
        case awaitingConfirmation
    }
    
    enum CodingKeys: String, CodingKey {
        case lrzID
        case token
        case state
    }
    
    case no
    case requestingToken(lrzID: String)
    case some(lrzID: String, token: String, state: State)
    
    var user: User? {
        guard case .some(let lrzID, let token, let state) = self else {
            return nil
        }
        return state == .loggedIn ? User(lrzID: lrzID, token: token) : nil
    }
    
    
    init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let lrzID = try container.decode(String.self, forKey: .lrzID)
            do {
                let token = try container.decode(String.self, forKey: .token)
                let state = try container.decode(State.self, forKey: .state)
                self = .some(lrzID: lrzID, token: token, state: state)
            } catch {
                self = .requestingToken(lrzID: lrzID)
            }
        } catch {
            self = .no
        }
    }
    
    func encode(to encoder: Encoder) throws {
        switch self {
        case .no:
            let dict = [String : String]()
            var container = encoder.singleValueContainer()
            try container.encode(dict)
        case .requestingToken(let lrzID):
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(lrzID, forKey: .lrzID)
        case .some(let lrzID, let token, let state):
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(lrzID, forKey: .lrzID)
            try container.encode(token, forKey: .token)
            try container.encode(state, forKey: .state)
        }
    }
    
}

private func fetchCredentialsFromDefaults() -> PersistendUserData? {
    let defaults = UserDefaults.standard
    guard let dictionary = defaults.dictionary(forKey: "AppDefaults.login") else {
        return nil
    }
    guard let lrzID = dictionary["lrzID"] as? String, let token = dictionary["token"] as? String else {
        return nil
    }
    return .some(lrzID: lrzID, token: token, state: .loggedIn)
}

struct PersistentUser: SingleStatus {
    static let storage: Storage = .keychain
    static let key: AppDefaults = .login
    
    static var defaultValue: PersistendUserData {
        
        guard let previousValue = fetchCredentialsFromDefaults() else {
            return .no
        }
        UserDefaults.standard.removeObject(forKey: "AppDefaults.login")
        UserDefaults.standard.synchronize()
        PersistentUser.value = previousValue
        return previousValue
    }
}


extension PersistentUser {
    
    static var isLoggedIn: Bool {
        if case .some(_, _, .loggedIn) = value {
            return true
        }
        return false
    }
    
    static var hasEnteredID: Bool {
        if case .no = value {
            return false
        }
        return true
    }
    
    static var hasRequestedToken: Bool {
        if case .some = value {
            return true
        }
        return false
    }
    
}
