//
//  PersonDetailedViewModel.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 05.02.22.
//

import Foundation
import Alamofire
import XMLCoder
import SwiftUI
import Contacts

enum DetailsType {
    case Person(Person)
    case Profile(Profile)
}

@MainActor
class PersonDetailedViewModel: ObservableObject {
    @Published var state: APIState<PersonDetails> = .na
    @Published var hasError: Bool = false
    
    let model: Model
    let service: PersonDetailedService
    let type: DetailsType
    
    init(model: Model, service: PersonDetailedService, type: DetailsType) {
        self.model = model
        self.service = service
        self.type = type
    }
    
    func getDetails(forcedRefresh: Bool) async {
        if !forcedRefresh {
            self.state = .loading
        }
        self.hasError = false
        
        guard let token = self.model.token else {
            self.state = .failed(error: NetworkingError.unauthorized)
            self.hasError = true
            return
        }
        
        do {
            
            if case .Person(let person) = type {
                self.state = .success(
                    data: try await service.fetch(for: person.obfuscatedID, token: token, forcedRefresh: forcedRefresh)
                )
            }
            if case .Profile(let profile) = type, let obfuscatedID = profile.obfuscatedID {
                self.state = .success(
                    data: try await service.fetch(for: obfuscatedID, token: token, forcedRefresh: forcedRefresh)
                )
            }
        } catch {
            self.state = .failed(error: error)
            self.hasError = true
        }
    }
    
    var cnContact: CNMutableContact {
        guard case .success(let personDetails) = state else {
            return CNMutableContact()
        }

        let contact = CNMutableContact()

        contact.contactType = .person
        if let title = personDetails.title {
            contact.namePrefix = title
        }
        contact.givenName = personDetails.firstName
        contact.familyName = personDetails.name

        contact.emailAddresses = [CNLabeledValue(label: CNLabelWork, value: personDetails.email as NSString)]
        if let organisation = personDetails.organisations.first {
            contact.departmentName = organisation.name
        }

        var phoneNumbers: [CNLabeledValue<CNPhoneNumber>] = personDetails.privateContact.compactMap { info in
            switch info {
            case .phone(let number), .mobilePhone(let number) : return CNLabeledValue(label: CNLabelWork, value: CNPhoneNumber(stringValue: number))
            default: return nil
            }
        }

        phoneNumbers.append(contentsOf: personDetails.officialContact.compactMap { info in
            switch info {
            case .phone(let number), .mobilePhone(let number) : return CNLabeledValue(label: CNLabelWork, value: CNPhoneNumber(stringValue: number))
            default: return nil
            }
        })

        phoneNumbers.append(contentsOf: personDetails.phoneExtensions.map { phoneExtension in
            return CNLabeledValue(label: CNLabelWork, value: CNPhoneNumber(stringValue: phoneExtension.phoneNumber))
        })

        contact.phoneNumbers = phoneNumbers

        if let imageData = personDetails.image?.jpegData(compressionQuality: 1) {
            contact.imageData = imageData
        }

        var urls: [CNLabeledValue<NSString>] = personDetails.privateContact.compactMap{ info in
            switch info {
            case .homepage(let urlString): return CNLabeledValue(label: CNLabelWork, value: urlString as NSString)
            default: return nil
            }
        }

        urls.append(contentsOf: personDetails.officialContact.compactMap { info in
            switch info {
            case .homepage(let urlString): return CNLabeledValue(label: CNLabelWork, value: urlString as NSString)
            default: return nil
            }
        })

        contact.urlAddresses = urls

        contact.organizationName = "TUM"
        if let room = personDetails.rooms.first {
            contact.note = room.locationDescription
        }

        return contact
    }
}
