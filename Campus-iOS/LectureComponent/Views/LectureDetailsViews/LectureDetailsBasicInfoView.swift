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
    @StateObject var personVM: PersonSearchViewModel
    let model: Model
    
    init(model: Model, lectureDetails: LectureDetails) {
        self.model = model
        self._personVM = StateObject(wrappedValue: PersonSearchViewModel(model: model, service: PersonSearchService()))
        self.lectureDetails = lectureDetails
    }
    
    var actionSheetButtons: [ActionSheet.Button] {
        self.lectureDetails.speakerArray.map( { speaker in
            ActionSheet.Button.default(Text(speaker), action: {
                self.chosenSpeaker = speaker
                self.navigationLinkActive = true
            })
        }) + [ActionSheet.Button.cancel()]
    }
    
    var body: some View {
        GroupBox(
            label: GroupBoxLabelView(
                iconName: "info.circle.fill",
                text: "Basic lecture information".localized
            )
            .padding(.bottom, 10)
        ) {
            NavigationLink(isActive: self.$navigationLinkActive, destination: {
                PersonSearchScreen(model: model, findPerson: chosenSpeaker)
            }) {
                EmptyView().onAppear{print("empty view")}
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
                HStack {
                    LectureDetailsBasicInfoRowView(
                        iconName: "person.fill",
                        text: lectureDetails.speaker
                    )
                    Spacer()
                    Button(
                        action: { self.showActionSheet = true },
                        label: { Image(systemName: "magnifyingglass").foregroundColor(.blue) }
                    )
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
        .actionSheet(isPresented: self.$showActionSheet) {
            ActionSheet(title: Text("Choose Speaker"), buttons: self.actionSheetButtons)
        }
        .frame(
              maxWidth: .infinity,
              alignment: .topLeading
        )
    }
}

struct LectureDetailsBasicInfoView_Previews: PreviewProvider {
    static var previews: some View {
        LectureDetailsBasicInfoView(model: Model(), lectureDetails: LectureDetails.dummyData)
    }
}
