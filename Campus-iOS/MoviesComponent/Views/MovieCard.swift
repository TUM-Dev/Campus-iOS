//
//  MovieCard.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 27.01.22.
//

import SwiftUI

struct MovieCard: View {
    
    @State var movie: Movie
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            if let link = self.movie.cover {
                AsyncImage(url: link) { image in
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
                        Image(decorative: "movie")
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
                
            } else {
                Image(decorative: "movie")
                    .resizable()
                    .frame(minWidth: nil, idealWidth: nil, maxWidth: UIScreen.main.bounds.width, minHeight: nil, idealHeight: nil, maxHeight: UIScreen.main.bounds.height, alignment: .center)
                    .clipped()
            }
            
            // Stack bottom half of card
            VStack(alignment: .leading, spacing: 2) {
                Text(self.movie.title ?? "")
                    .fontWeight(Font.Weight.heavy)
                    .font(.subheadline).foregroundColor(colorScheme == .dark ? .init(UIColor.white) : .init(UIColor.black))
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(1)
                Text(self.movie.date ?? Date(), style: .date)
                    .font(Font.custom("HelveticaNeue-Bold", size: 12))
                    .foregroundColor(Color.gray)
                Spacer()
            }
            .padding(EdgeInsets(top: 15, leading: 10, bottom: 10, trailing: 5))
            .frame(height: 55)
            
        }
        .frame(width: 390 * 0.425, height: 390 * 0.73)
        .background(Color(.systemGray5))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.2), radius: 7, x: 0, y: 2)
    }
}

struct MovieCard_Previews: PreviewProvider {
    
    static var movie = Movie(id: 1, actors: "Mark Wahlberg, Sophie Cookson", cover: URL(string: "https://m.media-amazon.com/images/M/MV5BZTU5MmY0ZjctYTNlOS00MDIyLWJkZTAtNzBiOTkyNWI5MGY2XkEyXkFqcGdeQXVyNTc4MjczMTM@._V1_FMjpg_UY720_.jpg"), created: Date(), date: Date(), director: "Antoine Fuqua", genre: "Fantasy", link: URL(string: "https://www.imdb.com/title/tt6654210/?ref_=ttmi_tt"), movieDescription: "A man discovers that his hallucinations are actually visions from past lives.", rating: "5.5/10", runtime: "1h 46m", title: "Infinite", year: "2021")
    
    static var previews: some View {
        MovieCard(movie: self.movie)
    }
}
