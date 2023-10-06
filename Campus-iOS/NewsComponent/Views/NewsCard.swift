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
                    .scaledToFit()
                    .frame(minWidth: nil, idealWidth: nil, maxWidth: UIScreen.main.bounds.width, minHeight: nil, idealHeight: nil, maxHeight: UIScreen.main.bounds.height, alignment: .top)
                    .clipped()
            } else {
                AsyncImage(url: URL(string: image)) { image in
                    switch image {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(minWidth: nil, idealWidth: nil, maxWidth: UIScreen.main.bounds.width, minHeight: nil, idealHeight: nil, maxHeight: UIScreen.main.bounds.height, alignment: .top)
                            .clipped()
                    case .failure:
                        Image("placeholder")
                            .resizable()
                            .scaledToFit()
                            .frame(minWidth: nil, idealWidth: nil, maxWidth: UIScreen.main.bounds.width, minHeight: nil, idealHeight: nil, maxHeight: UIScreen.main.bounds.height, alignment: .top)
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
            
            // Stack bottom half of card
            VStack(alignment: .leading) {
                Text(self.title)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.leading)
                Text(self.created, style: .date)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.top, 2)
                
                if self.latest {
                    if source != nil {
                        Text("Source: \(source!)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.leading)
                    }
                }
            }
            .padding(12)
            
        }
        .if(self.latest, transformT: {view in
            view.frame(width: 390 * 0.8)
        }, transformF: {view in
            view.frame(width: 390 * 0.8)
        })
            
            .background(Color.secondaryBackground)
            .cornerRadius(Radius.regular)
            
    }
}

struct ProductCard_Previews: PreviewProvider {
    static var previews: some View {
        NewsCard(title: "SMOOTHIE BOWL", source: "FEELING FIT", created: Date(), image: "https://app.tum.de/File/news/newspread/dab04abdf3954d3e1bf56cef44d68662.jpg", latest: false)
    }
}
