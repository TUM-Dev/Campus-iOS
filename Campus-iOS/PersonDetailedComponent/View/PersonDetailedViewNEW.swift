//
//  PersonDetailedViewNEW.swift
//  Campus-iOS
//
//  Created by Timothy Summers on 07.03.23.
//

import SwiftUI

@available(iOS 16.0, *)
struct PersonDetailedViewNEW: View {
    
    @StateObject var profileViewModel: ProfileViewModel
    @State private var showImageSheet = false
    @Binding var showProfileSheet: Bool
    var studyPrograms: [String]
    let personDetails: PersonDetails
    
    var body: some View {
        NavigationStack {
            VStack {
                if self.profileViewModel.profileImageUI == nil { //shows default profile icon
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 125, height: 125)
                        .foregroundColor(.gray)
                        .clipShape(Circle())
                        .onTapGesture {
                            showImageSheet = true
                        }
                } else { //show selected profile pic
                    Image(uiImage: self.profileViewModel.profileImageUI!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 125, height: 125)
                        .clipShape(Circle())
                        .onTapGesture {
                            showImageSheet = true
                        }
                }
                
                if let profile = self.profileViewModel.profile {
                    Text(profile.fullName)
                        .font(.title2)
                        .lineLimit(1)
                    ForEach(studyPrograms) { studyprogram in
                        Text(studyprogram)
                            .font(.subheadline)
                    }
                    Text(profile.tumID!)
                        .font(.subheadline)
                } else {
                    ProgressView()
                }
                
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

                
                Spacer()
            }
            .background(Color.primaryBackground.edgesIgnoringSafeArea(.all))
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        self.showProfileSheet.toggle()
                    }
                }
            }
        }
        .sheet(isPresented: $showImageSheet) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: self.$profileViewModel.profileImageUI)
        }
        .onChange(of: self.profileViewModel.profileImageUI) { newImage in //saves ProfileImage
            if let image = newImage {
                if let fileName = self.profileViewModel.save(image: image) {
                    print("Saved Image to: \(fileName)")
                } else {
                    print("Error in saving Image")
                }
            }
        }
    }
}
