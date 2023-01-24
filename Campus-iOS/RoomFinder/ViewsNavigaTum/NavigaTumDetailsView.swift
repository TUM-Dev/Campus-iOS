//
//  NavigaTumDetailsView.swift
//  Campus-iOS
//
//  Created by Atharva Mathapati on 07.01.23.
//

import SwiftUI


struct NavigaTumDetailsView: View {
    @StateObject var viewModel: NavigaTumDetailsViewModel

    var body: some View {
        ScrollView {
            Text(viewModel.errorMessage)
            if let chosenRoom = viewModel.details {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(chosenRoom.name)
                            .font(.title)
                            .multilineTextAlignment(.leading)
                        Text(chosenRoom.typeCommonName)
                            .font(.subheadline)
                    }
                    
                    Spacer().frame(height: 30)
                    NavigaTumDetailsBaseView(chosenRoom: chosenRoom)
                    NavigaTumMapView(chosenRoom: chosenRoom)
                }
                .frame(
                    maxWidth: .infinity,
                    alignment: .topLeading
                )
                .padding(.horizontal)
                // From MapHorizontalScrollingView
                /*
                if viewModel.images.count > 0 {
                    ScrollView (.horizontal, showsIndicators: true) {
                        HStack(spacing: 10) {
                            ForEach(viewModel.images, id: \.id) { map in
                                GeometryReader { geometry in
                                    if let link = URL(string: "https://nav.tum.de/cdn/maps/overlay/\(map)") {
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
                }
                */
                
                
                
                
                AsyncImage(url: URL(string: "https://nav.tum.de/cdn/maps/overlay/rf142.webp")) { image in
                        switch image {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            NavigationLink(destination: ImageFullScreenView(image: image)) {
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
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
                }
            }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.fetchDetails()
        }
    }
}

struct NavigaTumDetailsView_Previews: PreviewProvider {
    static let props = [NavigaTumNavigationProperty(name: "Roomcode", text: "5606.EG.036"), NavigaTumNavigationProperty(name: "Architect's name", text: "00.06.036"), NavigaTumNavigationProperty(name: "Address", text: "Boltzmannstr. 3, EG, 85748 Garching b. München")]
    static let additionalProperties = NavigaTumNavigationAdditionalProperties(properties: props)
    static let coords = NavigaTumNavigationCoordinates(latitude: 48.26217845031176, longitude: 11.668693278105701)
    static let available = [NavigaTumRoomFinderMap(id: "rf95", name: "FMI Garching BT06 EG", imageUrl: "rf95.webp", height: 605, width: 318, x: 207, y: 217, scale: "500"),
                            NavigaTumRoomFinderMap(id: "rf142", name: "FMI Übersicht", imageUrl: "rf142.webp", height: 461, width: 639, x: 443, y: 242, scale: "2000"),
                            NavigaTumRoomFinderMap(id: "rf80", name: "Lageplan Campus Garching", imageUrl: "rf80.webp", height: 480, width: 676, x: 329, y: 344, scale: "10000"),
                            NavigaTumRoomFinderMap(id: "rf54", name: "München", imageUrl: "rf54.webp", height: 603, width: 640, x: 444, y: 36, scale: "200000"),
                            NavigaTumRoomFinderMap(id: "rf156", name: "München und Umgebung", imageUrl: "rf156.webp", height: 515, width: 420, x: 265, y: 167, scale: "400000")]
    static let maps = NavigaTumNavigationMaps(default: "rf95", roomfinder: NavigaTumRoomFinderMaps(available: available , defaultMapId: "rf95"))
    static var chosenRoom = NavigaTumNavigationDetails(id: "5606.EG.036", name: "5606.EG.036 (MPI Fachschaftsbüro im MI)", parentNames: ["Standorte", "Garching Forschungszentrum","Fakultät Mathematik & Informatik (FMI oder MI)", "Finger 06 (BT06)"], type: "room", typeCommonName: "Office", additionalProperties: additionalProperties, coordinates: coords, maps: maps)
    static var viewmodel = NavigaTumDetailsViewModel(id: "5606.EG.036")
    static var previews: some View {
        NavigaTumDetailsView(viewModel: viewmodel)
    }
}

