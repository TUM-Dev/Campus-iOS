//
//  NavigaTumMapImagesView.swift
//  Campus-iOS
//
//  Created by Atharva Mathapati on 07.02.23.
//

import SwiftUI

struct NavigaTumMapImagesView: View {
    
    @State var chosenRoom: NavigaTumNavigationDetails
    
    var body: some View {
        GroupBox(
            label: GroupBoxLabelView(
                iconName: "photo.fill.on.rectangle.fill",
                text: "Room".localized
            )
            .padding(.bottom, 10)
        ) {
            
            Divider()
            
            if chosenRoom.maps.roomfinder.available.count > 0 {
                ScrollView (.horizontal, showsIndicators: true) {
                    HStack (spacing: 20) {
                        ForEach(chosenRoom.maps.roomfinder.available) { map in
                            GeometryReader { _ in
                                AsyncImage(url: URL(string: Constants.API.NavigaTum.images(id: map.imageUrl).fullPathURL)) { image in
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
                            .frame(width: 200, height: 200)
                            Spacer(minLength: 1)
                        }
                    }
                }
                .padding([.top, .bottom], 15)
            }
        }
    }
}

struct NavigaTumMapImagesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigaTumMapImagesView(chosenRoom: NavigaTumDetailsView_Previews.chosenRoom)
    }
}
