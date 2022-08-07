//
//  NewsCard.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 26.01.22.
//

import SwiftUI

struct LoadMoreCard: View {
    @Environment(\.colorScheme) var colorScheme
    
    let loadingMethod: () -> ()
    
    var body: some View {
            Button {
                withAnimation {
                    loadingMethod()
                }
            } label: {
                HStack {
                    Text("Show more...")
                        .font(.body)
                        .foregroundColor(.blue)
                }
                .foregroundColor(colorScheme == .dark ? .white : .black)
                .frame(width: 390 * 0.4, height: 390 * 0.6)
            }
            .background(Color(.systemGray6))
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.2), radius: 7, x: 0, y: 2)
            .contentShape(Rectangle())
            .padding(.leading)
    }
}

struct NewsCard: View {
    var title: String
    var source: String?
    var created: Date
    var image: String
    var latest: Bool
    
    init(title: String, source: String?, created: Date, image: String, latest: Bool) {
        
        self.title = title
        self.source = source
        self.created = created
        self.image = image
        self.latest = latest
    }
    
    init(news: (String?, News?), latest: Bool) {
        
        self.title = news.1?.title ?? ""
        self.source = news.0 ?? ""
        self.created = news.1?.created ?? Date()
        self.image = news.1?.imageURL ?? ""
        self.latest = latest
    }
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 0) {
            
            if self.image.isEmpty {
                Image("placeholder")
                    .resizable()
                    .frame(minWidth: nil, idealWidth: nil, maxWidth: UIScreen.main.bounds.width, minHeight: nil, idealHeight: nil, maxHeight: UIScreen.main.bounds.height, alignment: .center)
                    .clipped()
                    .if(self.latest) { view in
                        view.overlay(
                            Text("LATEST")
                                .fontWeight(Font.Weight.medium)
                                .font(Font.system(size: 14))
                                .foregroundColor(Color.white)
                                .padding([.leading, .trailing], 14)
                                .padding([.top, .bottom], 8)
                                .background(Color.black.opacity(0.3))
                                .mask(RoundedCornersShape(tl: 0, tr: 0, bl: 0, br: 15))
                            , alignment: .topLeading)
                    }
            } else {
                AsyncImage(url: URL(string: image)) { image in
                    switch image {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .frame(minWidth: nil, idealWidth: nil, maxWidth: UIScreen.main.bounds.width, minHeight: nil, idealHeight: nil, maxHeight: UIScreen.main.bounds.height, alignment: .center)
                            .clipped()
                            .if(self.latest) { view in
                                view.overlay(
                                    Text("LATEST")
                                        .fontWeight(Font.Weight.medium)
                                        .font(Font.system(size: 14))
                                        .foregroundColor(Color.white)
                                        .padding([.leading, .trailing], 14)
                                        .padding([.top, .bottom], 8)
                                        .background(Color.black.opacity(0.3))
                                        .mask(RoundedCornersShape(tl: 0, tr: 0, bl: 0, br: 15))
                                    , alignment: .topLeading)
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
            
            // Stack bottom half of card
            VStack(alignment: .leading, spacing: 6) {
                Text(self.title)
                    .fontWeight(Font.Weight.heavy)
                Text(self.created, style: .date)
                    .font(Font.custom("HelveticaNeue-Bold", size: 16))
                    .foregroundColor(Color.gray)
                
                if self.latest {
                    Divider()
                        .foregroundColor(Color.gray.opacity(0.3))
                        .padding([.leading, .trailing], -12)

                
                    HStack(alignment: .center, spacing: 6) {
                        
                        if source != nil {
                            Text("Source:")
                                .font(Font.system(size: 13))
                                .fontWeight(Font.Weight.heavy)
                            HStack {
                                Text(source!)
                                .font(Font.custom("HelveticaNeue-Medium", size: 12))
                                    .padding([.leading, .trailing], 10)
                                    .padding([.top, .bottom], 5)
                                .foregroundColor(Color.white)
                            }
                            .background(Color(red: 43/255, green: 175/255, blue: 187/255))
                            .cornerRadius(7)
                            Spacer()
                        }
                        
                    }
                    .padding([.top, .bottom], 8)
                }
            }
            .padding(12)
            
        }
        .if(self.latest, transformT: {view in
            view.frame(width: 390 * 0.8, height: 390 * 0.8)
        }, transformF: {view in
            view.frame(width: 390 * 0.8, height: 390 * 0.6)
        })
        
        .background(Color(.systemGray6))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.2), radius: 7, x: 0, y: 2)
        
    }
}

struct ProductCard_Previews: PreviewProvider {
    static var previews: some View {
        NewsCard(title: "SMOOTHIE BOWL", source: "FEELING FIT", created: Date(), image: "https://app.tum.de/File/news/newspread/dab04abdf3954d3e1bf56cef44d68662.jpg", latest: false)
        LoadMoreCard(loadingMethod: {print("loading mehtod")})
    }
}
