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

struct PersonDetailsHeader: Identifiable, Hashable {
    let id = UUID()
    let image: UIImage?
    let imageURL: URL?
    let name: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
    }
}

struct PersonDetailsCell: Identifiable, Hashable {
    enum ActionType {
        case call
        case mail
        case openURL
        case showRoom
    }

    let id = UUID()
    let key: String
    let value: String
    let actionType: ActionType?
}

struct PersonDetailsSection: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let cells: [AnyHashable]
}

class PersonDetailedViewModel: ObservableObject {
    var person: PersonDetails?
    var endpoint: TUMOnlineAPI
    
    @Published var sections: [PersonDetailsSection]?
    
    private let sessionManager = Session.defaultSession
    
    init(withId id: String) {
        self.endpoint = TUMOnlineAPI.personDetails(identNumber: id)
    }
    
    init(withPerson person: Person) {
        let header: PersonDetailsHeader
        if let personGroup = person.personGroup, let id = person.id {
            header = PersonDetailsHeader(image: nil, imageURL: TUMOnlineAPI.profileImage(personGroup: personGroup, id: id).urlRequest?.url, name: "\(person.title?.appending(" ") ?? "")\(person.firstName) \(person.name)")
        } else {
            header = PersonDetailsHeader(image: nil, imageURL: nil, name: "\(person.title?.appending(" ") ?? "")\(person.firstName) \(person.name)")
        }

        self.sections = [PersonDetailsSection(name: "Header", cells: [header])]
        self.endpoint = TUMOnlineAPI.personDetails(identNumber: person.obfuscatedID)
    }
    
    
    init(withProfile profile: Profile) {
        var sections: [PersonDetailsSection] = []

        let header: PersonDetailsHeader
        if let personGroup = profile.personGroup, let id = profile.id {
            header = PersonDetailsHeader(image: nil, imageURL: TUMOnlineAPI.profileImage(personGroup: personGroup, id: id).urlRequest?.url, name: "\(profile.firstname ?? "") \(profile.surname ?? "")")
        } else {
            header = PersonDetailsHeader(image: nil, imageURL: nil, name: "\(profile.firstname ?? "") \(profile.surname ?? "")")
        }
        sections.append(PersonDetailsSection(name: "Header", cells: [header]))

        if let tumID = profile.tumID {
            sections.append(PersonDetailsSection(name: "General", cells: [PersonDetailsCell(key: "TUM ID".localized, value: tumID, actionType: .none)]))
        }

        self.sections = sections
        self.endpoint = TUMOnlineAPI.personDetails(identNumber: profile.obfuscatedID ?? "")
    }
    
    func fetch() {
        self.sessionManager.request(self.endpoint).responseDecodable(of: PersonDetails.self, decoder: XMLDecoder()) { [weak self] response  in
            guard let value = response.value else { return }
            self?.person = value
            self?.fillFromProfileDetails()
        }
    }
    
    func fillFromProfileDetails() {
        let header: PersonDetailsHeader
        if let personGroup = self.person?.personGroup, let id = self.person?.id {
            header = PersonDetailsHeader(image: self.person?.image, imageURL: TUMOnlineAPI.profileImage(personGroup: personGroup, id: id).urlRequest?.url, name: "\(self.person?.title?.appending(" ") ?? "")\(self.person?.firstName.appending(" ") ?? "")\(self.person?.name ?? "")")
        } else {
            header = PersonDetailsHeader(image: self.person?.image, imageURL: nil, name: "\(self.person?.title?.appending(" ") ?? "")\(self.person?.firstName.appending(" ") ?? "")\(self.person?.name ?? "")")
        }

        var general: [PersonDetailsCell] = []
        if let email = self.person?.email, !email.isEmpty {
            general.append(PersonDetailsCell(key: "E-Mail".localized, value: email, actionType: .mail))
        }
        if let officeHours = self.person?.officeHours, !officeHours.isEmpty {
            general.append(PersonDetailsCell(key: "Office Hours".localized, value: officeHours, actionType: .none))
        }

        var officialContact: [PersonDetailsCell] = []
        if let contactInfo = self.person?.officialContact, contactInfo.count > 0 {
            officialContact = contactInfo.map { info in
                switch info {
                case let .phone(number): return PersonDetailsCell(key: "Phone".localized, value: number, actionType: .call)
                case let .mobilePhone(number): return PersonDetailsCell(key: "Mobile".localized, value: number, actionType: .call)
                case let .fax(number): return PersonDetailsCell(key: "Fax".localized, value: number, actionType: .none)
                case let .additionalInfo(additionalInfo): return PersonDetailsCell(key: "Additional Info".localized, value: additionalInfo, actionType: .none)
                case let .homepage(urlString): return PersonDetailsCell(key: "Homepage".localized, value: urlString, actionType: .openURL)
                }
            }
        }
        var privateContact: [PersonDetailsCell] = []
        if let privateContactInfo = self.person?.privateContact, privateContactInfo.count > 0 {
            privateContact = privateContactInfo.map { info in
                switch info {
                case let .phone(number): return PersonDetailsCell(key: "Phone".localized, value: number, actionType: .call)
                case let .mobilePhone(number): return PersonDetailsCell(key: "Mobile".localized, value: number, actionType: .call)
                case let .fax(number): return PersonDetailsCell(key: "Fax".localized, value: number, actionType: .none)
                case let .additionalInfo(additionalInfo): return PersonDetailsCell(key: "Additional Info".localized, value: additionalInfo, actionType: .none)
                case let .homepage(urlString): return PersonDetailsCell(key: "Homepage".localized, value: urlString, actionType: .openURL)
                }
            }
        }

        let phoneExtensions = self.person?.phoneExtensions.map { PersonDetailsCell(key: "Office".localized, value: $0.phoneNumber, actionType: .call) } ?? []

        let organisations = self.person?.organisations.map { PersonDetailsCell(key: "Organisation".localized, value: $0.name, actionType: .none) } ?? []

        let rooms = self.person?.rooms.map { PersonDetailsCell(key: "Room".localized, value: $0.shortLocationDescription, actionType: .showRoom) } ?? []

        self.sections = [
            PersonDetailsSection(name: "Header", cells: [header]),
            PersonDetailsSection(name: "General", cells: general),
            PersonDetailsSection(name: "Official Contact", cells: officialContact),
            PersonDetailsSection(name: "Private Contact", cells: privateContact),
            PersonDetailsSection(name: "Phone Extensions", cells: phoneExtensions),
            PersonDetailsSection(name: "Organisations", cells: organisations),
            PersonDetailsSection(name: "Rooms", cells: rooms)
            ].filter { !$0.cells.isEmpty }
    }
    
    var cnContact: CNMutableContact {
        guard let person = self.person else { return CNMutableContact() }

        let contact = CNMutableContact()

        contact.contactType = .person
        if let title = person.title {
            contact.namePrefix = title
        }
        contact.givenName = person.firstName
        contact.familyName = person.name

        contact.emailAddresses = [CNLabeledValue(label: CNLabelWork, value: person.email as NSString)]
        if let organisation = person.organisations.first {
            contact.departmentName = organisation.name
        }

        var phoneNumbers: [CNLabeledValue<CNPhoneNumber>] = person.privateContact.compactMap { info in
            switch info {
            case .phone(let number), .mobilePhone(let number) : return CNLabeledValue(label: CNLabelWork, value: CNPhoneNumber(stringValue: number))
            default: return nil
            }
        }

        phoneNumbers.append(contentsOf: person.officialContact.compactMap { info in
            switch info {
            case .phone(let number), .mobilePhone(let number) : return CNLabeledValue(label: CNLabelWork, value: CNPhoneNumber(stringValue: number))
            default: return nil
            }
        })

        phoneNumbers.append(contentsOf: person.phoneExtensions.map { phoneExtension in
            return CNLabeledValue(label: CNLabelWork, value: CNPhoneNumber(stringValue: phoneExtension.phoneNumber))
        })

        contact.phoneNumbers = phoneNumbers

        if let imageData = person.image?.jpegData(compressionQuality: 1) {
            contact.imageData = imageData
        }

        var urls: [CNLabeledValue<NSString>] = person.privateContact.compactMap{ info in
            switch info {
            case .homepage(let urlString): return CNLabeledValue(label: CNLabelWork, value: urlString as NSString)
            default: return nil
            }
        }

        urls.append(contentsOf: person.officialContact.compactMap { info in
            switch info {
            case .homepage(let urlString): return CNLabeledValue(label: CNLabelWork, value: urlString as NSString)
            default: return nil
            }
        })

        contact.urlAddresses = urls

        contact.organizationName = "TUM"
        if let room = person.rooms.first {
            contact.note = room.locationDescription
        }

        return contact
    }
}
