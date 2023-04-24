//
//  ContactCardView.swift
//  Campus-iOS
//
//  Created by Timothy Summers on 07.01.23.
//

import SwiftUI

@available(iOS 16.0, *)
struct ContactCardView: View {
    
    @StateObject var profileVm: ProfileViewModel
    @StateObject var gradesVm: GradesViewModel
    @StateObject var personDetailedVm: PersonDetailedViewModel
    @StateObject var model: Model
    @State private var showImageSheet = false
    @State private var showProfileSheet = false
    let profile: Profile
    
    var studyPrograms: [String] {
        var result = [String]()
        for index in self.gradesVm.gradesByDegreeAndSemester.indices {
            result.append(self.gradesVm.getStudyProgramNoID(studyID: self.gradesVm.gradesByDegreeAndSemester[index].0))
        }
        return result
    }
    
    init(model: Model, profile: Profile, profileVm: ProfileViewModel, gradesVm: GradesViewModel) {
        self._personDetailedVm = StateObject(wrappedValue: PersonDetailedViewModel(model: model, service: PersonDetailedService(), type: .Profile(profile)))
        self._gradesVm = StateObject(wrappedValue: gradesVm)
        self._profileVm = StateObject(wrappedValue: profileVm)
        self._model = StateObject(wrappedValue: model)
        self.profile = profile
    }
    
    var body: some View {
        HStack {
            if self.profileVm.profileImageUI == nil { //shows default profile icon
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
                Image(uiImage: self.profileVm.profileImageUI!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 70, height: 70)
                    .clipShape(Circle())
                    .onTapGesture {
                        showImageSheet = true
                    }
            }
            
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
                switch personDetailedVm.state {
                case .success(let personDetails):
                    Text(personDetails.email)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                default:
                    EmptyView()
                }
                ForEach(studyPrograms) { studyprogram in
                    Text(studyprogram)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .padding(.leading, 5)
            Spacer()
        }
        .sectionStyle()
        .task {
            await personDetailedVm.getDetails(forcedRefresh: true)
        }
        .sheet(isPresented: $showImageSheet) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: self.$profileVm.profileImageUI)
        }
        .sheet(isPresented: $showProfileSheet) {
            PersonDetailedScreenUser(model: self.model, profileVm: self.profileVm, studyPrograms: self.studyPrograms, showProfileSheet: self.$showProfileSheet, profile: self.profile)
        }.disabled(!self.profileVm.model.isUserAuthenticated)
        .onChange(of: self.profileVm.profileImageUI) { newImage in //saves ProfileImage
            if let image = newImage {
                if let fileName = self.profileVm.save(image: image) {
                    print("Saved Image to: \(fileName)")
                } else {
                    print("Error in saving Image")
                }
            }
        }
    }
}

