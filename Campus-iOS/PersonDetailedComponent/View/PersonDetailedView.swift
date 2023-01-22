//
//  PersonDetailedView.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 05.02.22.
//

import SwiftUI
import ContactsUI

struct PersonDetailedView: View {
    let imageSize: CGFloat = 125.0
    let personDetails: PersonDetails
    
    var body: some View {
        VStack {
            if let image = personDetails.image {
                Image(uiImage: image)
                    .resizable()
                    .clipShape(Circle())
                    .aspectRatio(contentMode: .fill)
                    .frame(width: imageSize, height: imageSize)
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .foregroundColor(Color(.secondaryLabel))
                    .frame(width: imageSize, height: imageSize)
            }
            Spacer().frame(height: 10)
            Text("\(personDetails.firstName) \(personDetails.name)").font(.system(size: 18))
            List {
                if !personDetails.email.isEmpty || !(personDetails.officeHours?.isEmpty ?? false) {
                    Section(header: Text("General")) {
                        if !personDetails.email.isEmpty, let mailURL = URL(string: "mailto:\(personDetails.email)") {
                            VStack(alignment: .leading) {
                                Text("E-Mail")
                                Link(personDetails.email, destination: mailURL)
                            }
                        }
                        if let officeHours = personDetails.officeHours, !officeHours.isEmpty {
                            VStack(alignment: .leading) {
                                Text("Office Hours")
                                Text(officeHours)
                            }
                        }
                    }
                }
                if !personDetails.officialContact.isEmpty {
                    Section(header: Text("Offical Contact")) {
                        ForEach(personDetails.officialContact) { contactInfo in
                            VStack(alignment: .leading) {
                                switch contactInfo {
                                case .phone(let phone):
                                    let number = phone.replacingOccurrences(of: " ", with: "")
                                    if let phoneURL = URL(string: "tel:\(number)") {
                                        Text("Phone")
                                        Link("\(phone)", destination: phoneURL)
                                    }
                                case .mobilePhone(let mobilePhone):
                                    let number = mobilePhone.replacingOccurrences(of: " ", with: "")
                                    if let mobilePhoneURL = URL(string: "tel:\(number)") {
                                        Text("Mobile")
                                        Link("\(mobilePhone)", destination: mobilePhoneURL)
                                    }
                                case .fax(let fax):
                                    Text("Fax")
                                    Text("\(fax)")
                                case .additionalInfo(let additionalInfo):
                                    Text("Additional Info")
                                    Text("\(additionalInfo)")
                                case .homepage(let homepage):
                                    if let homepageURL = URL(string: homepage) {
                                        Text("Hoomepage")
                                        Link("\(homepage)", destination: homepageURL)
                                    }
                                }
                            }
                        }
                    }
                }
                if !personDetails.privateContact.isEmpty {
                    Section(header: Text("Offical Contact")) {
                        ForEach(personDetails.privateContact) { contactInfo in
                            VStack(alignment: .leading) {
                                switch contactInfo {
                                case .phone(let phone):
                                    let number = phone.replacingOccurrences(of: " ", with: "")
                                    if let phoneURL = URL(string: "tel:\(number)") {
                                        Text("Phone")
                                        Link("\(phone)", destination: phoneURL)
                                    }
                                case .mobilePhone(let mobilePhone):
                                    let number = mobilePhone.replacingOccurrences(of: " ", with: "")
                                    if let mobilePhoneURL = URL(string: "tel:\(number)") {
                                        Text("Mobile")
                                        Link("\(mobilePhone)", destination: mobilePhoneURL)
                                    }
                                case .fax(let fax):
                                    Text("Fax")
                                    Text("\(fax)")
                                case .additionalInfo(let additionalInfo):
                                    Text("Additional Info")
                                    Text("\(additionalInfo)")
                                case .homepage(let homepage):
                                    if let homepageURL = URL(string: homepage) {
                                        Text("Hoomepage")
                                        Link("\(homepage)", destination: homepageURL)
                                    }
                                }
                            }
                        }
                    }
                }
                if !personDetails.phoneExtensions.isEmpty {
                    Section(header: Text("Phone Extensions")) {
                        ForEach(personDetails.phoneExtensions) { phoneExtension in
                            let number = phoneExtension.phoneNumber.replacingOccurrences(of: " ", with: "")
                            if let phoneNumberURL = URL(string: "tel:\(number)") {
                                VStack(alignment: .leading) {
                                    Text("Office")
                                    Link("\(phoneExtension.phoneNumber)", destination: phoneNumberURL)
                                }
                            }
                        }
                    }
                }
                
                if !personDetails.organisations.isEmpty {
                    Section(header: Text("Organisations")) {
                        ForEach(personDetails.organisations) { organisation in
                            VStack(alignment: .leading) {
                                Text("Organisation")
                                Text("\(organisation.name)")
                            }
                        }
                    }
                }
                
                if !personDetails.rooms.isEmpty {
                    Section(header: Text("Rooms")) {
                        ForEach(personDetails.rooms) { room in
                            VStack(alignment: .leading) {
                                Text("Room")
                                Text("\(room.shortLocationDescription)")
                            }
                        }
                    }
                }
            }
        }
    }
    
}
