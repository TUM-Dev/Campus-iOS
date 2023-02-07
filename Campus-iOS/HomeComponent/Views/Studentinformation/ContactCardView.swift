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
    @ObservedObject var personDetailedViewModel: PersonDetailedViewModel
    @State private var showImageSheet = false
    
    var body: some View {
        HStack {
            if self.profileViewModel.profileImageUI == nil {
                self.profileViewModel.profileImage
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 70, height: 70)
                    .foregroundColor(.gray)
                    .clipShape(Circle())
                    .onTapGesture {
                        showImageSheet = true
                    }
            } else {
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
                    Text(self.personDetailedViewModel.person?.email ?? "")
                        .font(.subheadline)
                        .foregroundColor(.gray)
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
        .sectionStyle()
        .sheet(isPresented: $showImageSheet) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: self.$profileViewModel.profileImageUI)
        }
    }
}

