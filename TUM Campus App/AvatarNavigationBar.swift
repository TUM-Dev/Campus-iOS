//
//  AvatarNavigationBar.swift
//  TUMCampusApp
//
//  Created by Tim Gymnich on 15.7.20.
//  Copyright © 2020 TUM. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import XMLCoder

fileprivate let sessionManager = Session.defaultSession
fileprivate let cacheKey = "avatar"

protocol ProfileImageSettable: class {
    var profileImage: UIImage? { get set }
}

extension ProfileImageSettable {

    func loadProfileImage() {
        let cache = ImageCache.default
        cache.clearDiskCache()

        cache.retrieveImage(forKey: cacheKey) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let value) where value.image != .none:
                self.profileImage = value.image
            default:
                self.downloadProfileImage()
            }
        }
    }

    fileprivate func downloadProfileImage() {
        sessionManager.request(TUMOnlineAPI.identify).responseDecodable(of: TUMOnlineAPIResponse<Profile>.self, decoder: XMLDecoder()) { [weak self] response in
            guard let self = self,
                let profile = response.value?.rows?.first,
                let obfuscatedID = profile.obfuscatedID,
                let group = profile.personGroup,
                let id = profile.id else { return }
            let imageRequest = TUMOnlineAPI.profileImage(personGroup: group, id: id)
            sessionManager.request(imageRequest).responseData(completionHandler: { response in
                if let imageData = response.value, let image = UIImage(data: imageData) {
                    self.setImage(image)
                    return
                }

                sessionManager.request(TUMOnlineAPI.personDetails(identNumber: obfuscatedID)).responseDecodable(of: PersonDetail.self, decoder: XMLDecoder()) { response in
                    guard let image = response.value?.image else { return }
                    self.setImage(image)
                }
            })
        }
    }

    fileprivate func setImage(_ image: UIImage) {
        let cache = ImageCache.default
        cache.store(image, forKey: cacheKey, toDisk: true)

        profileImage = image
    }
}
