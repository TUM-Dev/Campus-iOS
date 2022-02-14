//
//  LectureDetailsBasicInfoView.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 26.12.21.
//

import SwiftUI

struct LectureDetailsBasicInfoView: View {
    
    @State var showActionSheet = false
    @State private var navigationLinkActive = false
    @State private var chosenSpeaker = ""
    
    var lectureDetails: LectureDetails
    
    var viewModelPersonSearch: PersonSearchViewModel {
        let viewModel = PersonSearchViewModel()
        if(self.chosenSpeaker.count > 3) {
            viewModel.fetch(searchString: self.chosenSpeaker)
        }
        return viewModel
    }
    
    var body: some View {
        GroupBox(
            label: GroupBoxLabelView(
                iconName: "info.circle.fill",
                text: "Basic lecture information"
            )
            .padding(.bottom, 10)
        ) {
            NavigationLink(isActive: self.$navigationLinkActive, destination: {
                PersonSearchView(viewModel: self.viewModelPersonSearch, searchText: self.chosenSpeaker)
            }) {
                EmptyView()
            }
            
            VStack(alignment: .leading, spacing: 8) {
                LectureDetailsBasicInfoRowView(
                    iconName: "hourglass",
                    text: "\(lectureDetails.duration) SWS"
                )
                Divider()
                LectureDetailsBasicInfoRowView(
                    iconName: "graduationcap.fill",
                    text: lectureDetails.semester
                )
                Divider()
                LectureDetailsBasicInfoRowView(
                    iconName: "book.fill",
                    text: lectureDetails.organisation
                )
                Divider()
                LectureDetailsBasicInfoRowView(
                    iconName: "person.fill",
                    text: lectureDetails.speaker
                )
                .onTapGesture {
                    self.showActionSheet = true
                }
                if let firstMeeting = lectureDetails.firstScheduledDate {
                    Divider()
                    LectureDetailsBasicInfoRowView(
                        iconName: "clock.fill",
                        text: firstMeeting
                    )
                }
            }
        }
        .confirmationDialog("Choose Speaker", isPresented: self.$showActionSheet) {
            ForEach( self.lectureDetails.speakerArray ) { speaker in
                Button(speaker) {
                    self.chosenSpeaker = speaker
                    self.navigationLinkActive = true
                }
            }
            Button("Cancel", role: .cancel) { }
        }
        .frame(
              maxWidth: .infinity,
              alignment: .topLeading
        )
    }
}

struct LectureDetailsBasicInfoView_Previews: PreviewProvider {
    static var previews: some View {
        LectureDetailsBasicInfoView(lectureDetails: LectureDetails.dummyData)
    }
}
