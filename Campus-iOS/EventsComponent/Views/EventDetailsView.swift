//
//  EventDetailsView.swift
//  Campus-iOS
//
//  Created by Atharva Mathapati on 08.06.23.
//

import SwiftUI

struct EventDetailsView: View {
    var event: TUMEvent
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text(event.title)
                .font(.title)
                .multilineTextAlignment(.leading)
            
            GroupBox(
                label: GroupBoxLabelView(
                    iconName: "info.circle.fill",
                    text: "Event Details".localized
                )
                .padding(.bottom, 10)
            ) {
                VStack(alignment: .leading, spacing: 8) {
                    LectureDetailsBasicInfoRowView(
                        iconName: "qrcode.viewfinder",
                        text: event.title
                    )
                    Divider()
                    LectureDetailsBasicInfoRowView(
                        iconName: "person.fill",
                        text: event.user
                    )
                    Divider()
                    LectureDetailsBasicInfoRowView(
                        iconName: "link",
                        text: event.link
                    )
                    Divider()
                    LectureDetailsBasicInfoRowView(
                        iconName: "doc.plaintext",
                        text: event.body
                    )
                }
            }
            .frame(
                maxWidth: .infinity,
                alignment: .topLeading
            )
            
            if let link = event.image {
                GroupBox(
                    label: GroupBoxLabelView(
                        iconName: "photo.fill",
                        text: "Image".localized
                    )
                    .padding(.bottom, 10)
                ) {
                    AsyncImage(url: URL(string: link)) { image in
                        switch image {
                        case .empty:
                            ProgressView().padding(UIScreen.main.bounds.width/2)
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 390 * 0.425, height: 390 * 0.6)
                                .clipped()
                        case .failure:
                            Image("Image")
                                .resizable()
                                .frame(minWidth: nil, idealWidth: nil, maxWidth: UIScreen.main.bounds.width, minHeight: nil, idealHeight: nil, maxHeight: UIScreen.main.bounds.height, alignment: .center)
                                .clipped()
                        @unknown default:
                            // Since the AsyncImagePhase enum isn't frozen,
                            // we need to add this currently unused fallback
                            // to handle any new cases that might be added
                            // in the future:
                            EmptyView()
                        }
                    }
                }
                .frame(
                    maxWidth: .infinity,
                    alignment: .topLeading
                )
            }
        }
        .padding(.horizontal)
    }
}

struct EventDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        EventDetailsView(event: EventElementView_Previews.event)
    }
}
