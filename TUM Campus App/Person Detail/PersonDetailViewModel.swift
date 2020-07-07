//
//  PersonDetailViewModel.swift
//  TUMCampusApp
//
//  Created by Tim Gymnich on 4.7.20.
//  Copyright © 2020 TUM. All rights reserved.
//

import UIKit

struct PersonDetailViewModel: Hashable {
    let sections: [Section]

    struct Header: Identifiable, Hashable {
        let id = UUID()
        let image: UIImage?
        let imageURL: URL?
        let name: String
    }

    struct Cell: Identifiable, Hashable {
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

    struct Section: Identifiable, Hashable {
        let id = UUID()
        let name: String
        let cells: [AnyHashable]
    }

    init(profile: Profile) {
        var sections: [Section] = []

        let header: Header
        if let personGroup = profile.personGroup, let id = profile.id {
            header = Header(image: nil, imageURL: TUMOnlineAPI.profileImage(personGroup: personGroup, id: id).urlRequest?.url, name: "\(profile.firstname ?? "") \(profile.surname ?? "")")
        } else {
            header = Header(image: nil, imageURL: nil, name: "\(profile.firstname ?? "") \(profile.surname ?? "")")
        }
        sections.append(Section(name: "Header", cells: [header]))

        if let tumID = profile.tumID {
            sections.append(Section(name: "General", cells: [Cell(key: "TUM ID".localized, value: tumID, actionType: .none)]))
        }

        self.sections = sections
    }

    init(person: Person) {
        let header: Header
        if let personGroup = person.personGroup, let id = person.id {
            header = Header(image: nil, imageURL: TUMOnlineAPI.profileImage(personGroup: personGroup, id: id).urlRequest?.url, name: "\(person.title?.appending(" ") ?? "")\(person.firstName) \(person.name)")
        } else {
            header = Header(image: nil, imageURL: nil, name: "\(person.title?.appending(" ") ?? "")\(person.firstName) \(person.name)")
        }

        self.sections = [Section(name: "Header", cells: [header])]
    }

    init(person: PersonDetail) {
        let header: Header
        if let personGroup = person.personGroup, let id = person.id {
            header = Header(image: person.image, imageURL: TUMOnlineAPI.profileImage(personGroup: personGroup, id: id).urlRequest?.url, name: "\(person.title?.appending(" ") ?? "")\(person.firstName) \(person.name)")
        } else {
            header = Header(image: person.image, imageURL: nil, name: "\(person.title?.appending(" ") ?? "")\(person.firstName) \(person.name)")
        }

        var general: [Cell] = []
        general.append(Cell(key: "E-Mail".localized, value: person.email, actionType: .mail))
        if let officeHours = person.officeHours, !officeHours.isEmpty {
            general.append(Cell(key: "Office Hours".localized, value: officeHours, actionType: .none))
        }

        let officialContact: [Cell] = person.officialContact.map { info in
            switch info {
            case let .phone(number): return Cell(key: "Phone".localized, value: number, actionType: .call)
            case let .mobilePhone(number): return Cell(key: "Mobile".localized, value: number, actionType: .call)
            case let .fax(number): return Cell(key: "Fax".localized, value: number, actionType: .none)
            case let .additionalInfo(additionalInfo): return Cell(key: "Additional Info".localized, value: additionalInfo, actionType: .none)
            case let .homepage(urlString): return Cell(key: "Homepage".localized, value: urlString, actionType: .openURL)
            }
        }

        let privateContact: [Cell] = person.privateContact.map { info in
            switch info {
            case let .phone(number): return Cell(key: "Phone".localized, value: number, actionType: .call)
            case let .mobilePhone(number): return Cell(key: "Mobile".localized, value: number, actionType: .call)
            case let .fax(number): return Cell(key: "Fax".localized, value: number, actionType: .none)
            case let .additionalInfo(additionalInfo): return Cell(key: "Additional Info".localized, value: additionalInfo, actionType: .none)
            case let .homepage(urlString): return Cell(key: "Homepage".localized, value: urlString, actionType: .openURL)
            }
        }

        let phoneExtensions = person.phoneExtensions.map { Cell(key: "Office".localized, value: $0.phoneNumber, actionType: .call) }

        let organisations = person.organisations.map { Cell(key: "Organisation".localized, value: $0.name, actionType: .none) }

        let rooms = person.rooms.map { Cell(key: "Room".localized, value: $0.shortLocationDescription, actionType: .showRoom) }

        self.sections = [
            Section(name: "Header", cells: [header]),
            Section(name: "General", cells: general),
            Section(name: "Official Contact", cells: officialContact),
            Section(name: "Private Contact", cells: privateContact),
            Section(name: "Phone Extensions", cells: phoneExtensions),
            Section(name: "Organisations", cells: organisations),
            Section(name: "Rooms", cells: rooms)
            ].filter { !$0.cells.isEmpty }
    }

}
