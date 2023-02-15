//
//  ContactCardView.swift
//  Campus-iOS
//
//  Created by Timothy Summers on 07.01.23.
//

import SwiftUI

struct ContactCardView: View {
    
    @StateObject var profileViewModel: ProfileViewModel
    @StateObject var gradesViewModel: GradesViewModel
    @StateObject var personDetailedViewModel: PersonDetailedViewModel
    @State private var showImageSheet = false
    
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
                    Text(profile.fullName)
                        .font(.title2)
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
                    ForEach(self.gradesViewModel.gradesByDegreeAndSemester.indices, id: \.self) { index in
                        Text(
                            self.gradesViewModel.getStudyProgramNoID(studyID: self.gradesViewModel.gradesByDegreeAndSemester[index].0)
                        )
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    }
                }.padding(.leading, 5)
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
    }
}

