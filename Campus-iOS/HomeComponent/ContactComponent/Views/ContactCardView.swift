//
//  ContactCardView.swift
//  Campus-iOS
//
//  Created by Timothy Summers on 07.01.23.
//

import SwiftUI

@available(iOS 16.0, *)
struct ContactCardView: View {
    
    @StateObject var profileViewModel: ProfileViewModel
    @StateObject var gradesViewModel: GradesViewModel
    @StateObject var personDetailedViewModel: PersonDetailedViewModel
    @State private var showImageSheet = false
    @State private var showProfileSheet = false
    
    var studyPrograms: [String] {
        var result = [String]()
        for index in self.gradesViewModel.gradesByDegreeAndSemester.indices {
            result.append(self.gradesViewModel.getStudyProgramNoID(studyID: self.gradesViewModel.gradesByDegreeAndSemester[index].0))
        }
        return result
    }
    
    var body: some View {
        HStack {
            if self.profileViewModel.profileImageUI == nil { //shows default profile icon
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 70, height: 70)
                    .foregroundColor(.gray)
                    .clipShape(Circle())
                    .onTapGesture {
                        showImageSheet = true
                    }
            } else { //show selected profile pic
                Image(uiImage: self.profileViewModel.profileImageUI!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 70, height: 70)
                    .clipShape(Circle())
                    .onTapGesture {
                        showImageSheet = true
                    }
            }
            
            if let profile = self.profileViewModel.profile {
                VStack(alignment: .leading) {
                    HStack {
                        Text(profile.fullName)
                            .font(.title2)
                            .lineLimit(1)
                        Spacer(minLength: 5)
                        Image(systemName: "chevron.right")
                            .foregroundColor(Color.primaryText)
                            .frame(width: 5)
                            .onTapGesture {
                                showProfileSheet = true
                            }
                    }
                    Text(profile.tumID!)
                        .font(.subheadline)
                    if let email = personDetailedViewModel.person?.email {
                        Text(email)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    } else {
                        Text(verbatim: "timothy.summers@tum.de")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    ForEach(studyPrograms) { studyprogram in
                        Text(studyprogram)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.leading, 5)
            } else {
                ProgressView()
            }
            Spacer()
        }
        .task {
            personDetailedViewModel.fetch()
        }
        .sectionStyle()
        .sheet(isPresented: $showImageSheet) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: self.$profileViewModel.profileImageUI)
        }
        .sheet(isPresented: $showProfileSheet) {
            PersonDetailedViewNEW(profileViewModel: self.profileViewModel, personDetailedViewModel: self.personDetailedViewModel, showProfileSheet: self.$showProfileSheet, studyPrograms: self.studyPrograms)
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

