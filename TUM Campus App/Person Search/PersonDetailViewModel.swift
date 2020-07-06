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

    struct Header: Hashable {
        let image: UIImage?
        let imageURL: URL?
        let name: String
    }

    struct Cell: Hashable {
        enum ActionType {
            case call
            case mail
            case openURL
            case showRoom
        }

        let key: String
        let value: String
        let actionType: ActionType?
    }

    struct Section: Hashable {
        let name: String
        let cells: [AnyHashable]
    }

    init(profile: Profile) {
        var sections: [Section] = []

        if let tumID = profile.tumID {
            sections.append(Section(name: "General", cells: [Cell(key: "TUM ID".localized, value: tumID, actionType: .none)]))
        }

        let header: Header
        if let personGroup = profile.personGroup, let id = profile.id {
            header = Header(image: nil, imageURL: TUMOnlineAPI.profileImage(personGroup: personGroup, id: id).urlRequest?.url, name: "\(profile.firstname ?? "") \(profile.surname ?? "")")
        } else {
            header = Header(image: nil, imageURL: nil, name: "\(profile.firstname ?? "") \(profile.surname ?? "")")
        }
        sections.append(Section(name: "Header", cells: [header]))

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
        var sections: [Section] = []

        let header: Header
        if let personGroup = person.personGroup, let id = person.id {
            header = Header(image: person.image, imageURL: TUMOnlineAPI.profileImage(personGroup: personGroup, id: id).urlRequest?.url, name: "\(person.title?.appending(" ") ?? "")\(person.firstName) \(person.name)")
        } else {
            header = Header(image: person.image, imageURL: nil, name: "\(person.title?.appending(" ") ?? "")\(person.firstName) \(person.name)")
        }
        sections.append(Section(name: "Header", cells: [header]))

        var general: [Cell] = []
        general.append(Cell(key: "E-Mail".localized, value: person.email, actionType: .mail))
        if let officeHours = person.officeHours, !officeHours.isEmpty {
            general.append(Cell(key: "Office Hours".localized, value: officeHours, actionType: .none))
        }
        sections.append(Section(name: "General", cells: general))

        let officialContact: [Cell] = person.officialContact.map { info in
            switch info {
            case let .phone(number): return Cell(key: "Phone".localized, value: number, actionType: .call)
            case let .mobilePhone(number): return Cell(key: "Mobile".localized, value: number, actionType: .call)
            case let .fax(number): return Cell(key: "Fax".localized, value: number, actionType: .none)
            case let .additionalInfo(additionalInfo): return Cell(key: "Additional Info".localized, value: additionalInfo, actionType: .none)
            case let .homepage(urlString): return Cell(key: "Homepage".localized, value: urlString, actionType: .openURL)
            }
        }
        sections.append(Section(name: "Official Contact", cells: officialContact))

        let privateContact: [Cell] = person.privateContact.map { info in
            switch info {
            case let .phone(number): return Cell(key: "Phone".localized, value: number, actionType: .call)
            case let .mobilePhone(number): return Cell(key: "Mobile".localized, value: number, actionType: .call)
            case let .fax(number): return Cell(key: "Fax".localized, value: number, actionType: .none)
            case let .additionalInfo(additionalInfo): return Cell(key: "Additional Info".localized, value: additionalInfo, actionType: .none)
            case let .homepage(urlString): return Cell(key: "Homepage".localized, value: urlString, actionType: .openURL)
            }
        }
        sections.append(Section(name: "Private Contact", cells: privateContact))

        let phoneExtensions = person.phoneExtensions.map { Cell(key: "Office".localized, value: $0.phoneNumber, actionType: .call) }
        sections.append(Section(name: "Phone Extensions", cells: phoneExtensions))

        let organisations = person.organisations.map { Cell(key: "Organisation".localized, value: $0.name, actionType: .none) }
        sections.append(Section(name: "Organisations", cells: organisations))

        let rooms = person.rooms.map { Cell(key: "Room".localized, value: $0.shortLocationDescription, actionType: .showRoom) }
        sections.append(Section(name: "Rooms", cells: rooms))

        self.sections = sections.filter { !$0.cells.isEmpty }
    }

}
