//
//  MapImagesHorizontalScrollingView.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 05.06.22.
//

import SwiftUI

struct FoundRoomMapImagesHorizontalScrollingView: View {
    
    @ObservedObject var viewModel: FoundRoomViewModel
    
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

struct FoundRoomMapImagesHorizontalScrollingView_Previews: PreviewProvider {
    static var previews: some View {
        FoundRoomMapImagesHorizontalScrollingView(viewModel: FoundRoomViewModel(foundRoom: FoundRoom(roomId: "123", roomCode: "000", buildingNumber: "0000", id: "9876", info: "no info", address: "Boltzmannstraße X, Garching", purpose: "X", campus: "Garching", name: "Super Room")))
    }
}

struct StudyRoomMapImagesHorizontalScrollingView: View {
    
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

struct StudyRoomMapImagesHorizontalScrollingView_Previews: PreviewProvider {
    static var previews: some View {
        StudyRoomMapImagesHorizontalScrollingView(viewModel: StudyRoomViewModel(studyRoom: StudyRoomCoreData()))
    }
}
