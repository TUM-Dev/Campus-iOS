//
//  ProfileViewModel.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 07.02.22.
//

import Foundation
import Alamofire
import XMLCoder
import SwiftUI

class ProfileViewModel: ObservableObject {
    
    @Published var profile: Profile?
    @Published var tuition: Tuition?
    @Published var profileImage = Image(systemName: "person.crop.circle.fill")
    
    private let sessionManager = Session.defaultSession
    
    var profileState : ProfileState = .na
    var tuitionState : TuitionState = .na
    
    static let defaultProfile = Profile(
        firstname: nil,
        surname: "TUM Student".localized,
        tumId: "TUM ID",
        obfuscatedID: nil,
        obfuscatedIDEmployee: nil,
        obfuscatedIDExtern: nil,
        obfuscatedIDStudent: nil
    )
    
    init() {
        self.profile = Self.defaultProfile
    }
    
    init(model: Model) {
        switch model.loginController.credentials {
        case .none, .noTumID:
            self.profile = Self.defaultProfile
        case .tumID(_, _), .tumIDAndKey(_, _, _):
            fetch()
        }
    }
    
    func fetch(callback: @escaping (Result<Bool,Error>) -> Void = {_ in }) {
        let importer = Importer<Profile,TUMOnlineAPIResponse<Profile>, XMLDecoder>(endpoint: TUMOnlineAPI.identify)
        importer.performFetch( handler: { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let storage):
                    self.profile = storage.rows?.first
                    if let personGroup = self.profile?.personGroup, let personId = self.profile?.id, let obfuscatedID = self.profile?.obfuscatedID {
                        self.downloadProfileImage(personGroup: personGroup, personId: personId, obfuscatedID: obfuscatedID)
                    }
                    
                    self.checkTuitionFunc()
                    
                    if let _ = self.profile {
                        callback(.success(true))
                    } else {
                        callback(.failure(TUMOnlineAPIError.noPermission))
                    }
                case .failure(let error):
                    callback(.failure(error))
                    print(error)
                }
            }
        })
    }
    
    func downloadProfileImage(personGroup: String, personId: String, obfuscatedID: String) {
        let imageRequest = TUMOnlineAPI.profileImage(personGroup: personGroup, id: personId)
        self.sessionManager.request(imageRequest).responseData(completionHandler: { response in
            if let imageData = response.value, let image = UIImage(data: imageData) {
                self.profileImage = Image(uiImage: image)
                return
            }

            self.sessionManager.request(TUMOnlineAPI.personDetails(identNumber: obfuscatedID)).responseDecodable(of: PersonDetails.self, decoder: XMLDecoder()) { response in
                guard let image = response.value?.image else { return }
                self.profileImage = Image(uiImage: image)
            }
        })
    }
    
    func checkTuitionFunc(callback: @escaping (Result<Bool,Error>) -> Void = {_ in }) {
        
        let importerTuition = Importer<Tuition,TUMOnlineAPIResponse<Tuition>,
                        XMLDecoder>(endpoint: TUMOnlineAPI.tuitionStatus, dateDecodingStrategy: .formatted(DateFormatter.yyyyMMdd))
        
        DispatchQueue.main.async {
            importerTuition.performFetch(handler: { result in
                switch result {
                case .success(let storage):
                    self.tuition = storage.rows?.first
                    if let _ = self.tuition {
                        callback(.success(true))
                    } else {
                        callback(.failure(TUMOnlineAPIError.noPermission))
                    }
                case .failure(let error):
                    callback(.failure(error))
                    print(error)
                }
            })
        }
          
    }
}

extension ProfileViewModel {
    enum ProfileState {
        case na
        case loading
        case success(data: Profile?)
        case failed(error: Error)
    }
    
    enum TuitionState {
        case na
        case loading
        case success(data: Tuition?)
        case failed(error: Error)
    }
}
