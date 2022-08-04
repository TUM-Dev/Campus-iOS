//
//  MapImagesHorizontalScrollingView.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 05.06.22.
//

import SwiftUI

struct MapImagesHorizontalScrollingView: View {
    
    @ObservedObject var viewModel: StudyRoomViewModel
    
    var body: some View {
        if viewModel.roomImageMapping.count > 0  {
            ScrollView(.horizontal, showsIndicators: true) {
                HStack(spacing: 10) {
                    ForEach(viewModel.roomImageMapping, id: \.id) { map in
                        GeometryReader { geometry in
                            if let link = viewModel.getImageURL(imageMappingId: map.id) {
                                AsyncImage(url: link) { image in
                                    switch image {
                                    case .empty:
                                        ProgressView()
                                    case .success(let image):
                                        NavigationLink(destination: ImageFullScreenView(image: image)) {
                                            image
                                                .resizable()
                                                .frame(minWidth: nil, idealWidth: nil, maxWidth: UIScreen.main.bounds.width, minHeight: nil, idealHeight: nil, maxHeight: UIScreen.main.bounds.height, alignment: .center)
                                                .clipped()
                                                .cornerRadius(10.0)
                                        }
                                    case .failure:
                                        Image(systemName: "photo")
                                    @unknown default:
                                        // Since the AsyncImagePhase enum isn't frozen,
                                        // we need to add this currently unused fallback
                                        // to handle any new cases that might be added
                                        // in the future:
                                        EmptyView()
                                    }
                                }
                            } else {
                                EmptyView()
                            }
                        }
                        .frame(width: 100, height: 100)
                        Spacer(minLength: 1)
                    }
                }
            }
            .padding([.top, .bottom], 15)
        } else {
            HStack {
                Spacer()
                Text("Missing Map Images")
                    .bold()
                Spacer()
            }
        }
    }
}

struct MapImagesHorizontalScrollingView_Previews: PreviewProvider {
    static var previews: some View {
        MapImagesHorizontalScrollingView(viewModel: StudyRoomViewModel(studyRoom: StudyRoom()))
    }
}
