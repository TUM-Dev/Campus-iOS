//
//  ContactView.swift
//  Campus-iOS
//
//  Created by Timothy Summers on 30.12.22.
//

import SwiftUI

struct ContactView: View {
    @StateObject var profileViewModel: ProfileViewModel
    @StateObject var gradesViewModel: GradesViewModel
    @ObservedObject var personDetailedViewModel: PersonDetailedViewModel
    @State private var isShowingDetailView = false
    let moodleUrl = URL(string: "https://www.moodle.tum.de/my/")!
    let campusUrl = URL(string: "https://campus.tum.de/tumonline/ee/ui/ca2/app/desktop/#/login")!
    
    init (profileViewModel: ProfileViewModel, gradesViewModel: GradesViewModel) {
        self._profileViewModel = StateObject(wrappedValue: profileViewModel
                                            )
        self._gradesViewModel = StateObject(wrappedValue: gradesViewModel
                                            )
        self.personDetailedViewModel = PersonDetailedViewModel(withProfile: profileViewModel.profile ?? ProfileViewModel.defaultProfile)
        self.personDetailedViewModel.fetch()
    }
    
    var formattedAmount: String {
        guard let amount = profileViewModel.tuition?.amount else {
            return "n/a"
        }
        return OpenTuitionAmountView.currencyFormatter.string(from: amount) ?? "n/a"
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if let profile = self.profileViewModel.profile,
               let profileImage = self.profileViewModel.profileImage {
                HStack {
                    Text("Studentinformation")
                        .font(.headline.bold())
                        .textCase(.uppercase)
                        .foregroundColor(Color("tumBlue"))
                    Spacer()
                }
                .padding(.leading, 40)
                .padding(.bottom, 5)
                HStack {
                    profileImage
                        .resizable()
                        .clipShape(Circle())
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 70, height: 70)
                        .foregroundColor(Color(.secondaryLabel))
                    
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
                    Spacer()
                }
                .padding()
                .frame(width: UIScreen.main.bounds.size.width * 0.9)
                .background(Color.secondaryBackground)
                .clipShape(RoundedRectangle(cornerRadius: Radius.regular))
                .padding(.bottom, 10)
            } else {
                ProgressView()
            }
            
            NavigationLink(destination: TuitionView(viewModel: profileViewModel).navigationBarTitle(Text("Tuition fees"))) {
                Label {
                    HStack {
                        Text("Tuition fees").foregroundColor(Color.primaryText)
                        if let isOpenAmount = profileViewModel.tuition?.isOpenAmount, isOpenAmount != true {
                            Spacer()
                            Text("✅")
                        } else {
                            Spacer()
                            Text(self.formattedAmount).foregroundColor(.red)
                        }
                        Image(systemName: "chevron.right").foregroundColor(Color.primaryText)
                    }
                } icon: {
                    Image(systemName: "eurosign.circle").foregroundColor(Color.primaryText)
                }
                .padding(.vertical, 15)
                .padding(.horizontal)
            }
            .frame(width: UIScreen.main.bounds.size.width * 0.9)
            .background(Color.secondaryBackground)
            .clipShape(RoundedRectangle(cornerRadius: Radius.regular))
            .padding(.bottom, 10)
            
            HStack {
                Button (action: {
                    UIApplication.shared.open(self.moodleUrl)
                }) {
                    Label("Moodle", systemImage: "book.closed")
                        .foregroundColor(Color.primaryText)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(Color.secondaryBackground)
                }
                .clipShape(RoundedRectangle(cornerRadius: Radius.regular))
                Spacer()
                Button (action: {
                    UIApplication.shared.open(self.campusUrl)
                }) {
                    Label("TUMOnline", systemImage: "globe")
                        .foregroundColor(Color.primaryText)
                        .padding(.vertical, 15)
                        .frame(maxWidth: .infinity)
                        .background(Color.secondaryBackground)
                }
                .clipShape(RoundedRectangle(cornerRadius: Radius.regular))
            }
            .frame(width: UIScreen.main.bounds.size.width * 0.9)
            .padding(.bottom)
            
        }
    }
}
