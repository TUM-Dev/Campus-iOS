//
//  MovieDetailedView.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 27.01.22.
//

import SwiftUI
import UIKit

struct MovieDetailedView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var movie: Movie
    
    var body: some View {
        ZStack {
            VStack {
                Color.gray.opacity(0.4).ignoresSafeArea()
                Color.white.ignoresSafeArea()
            }
            
            VStack(alignment: .center) {
                if let link = self.movie.cover {
                    AsyncImage(url: link) { image in
                        switch image {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(height: 225, alignment: .top)
                        case .failure:
                            Image("movie")
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
                    Image("movie")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 120, alignment: .top)
                }
                details().cornerRadius(20)
            }.edgesIgnoringSafeArea(.bottom)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
                HStack(alignment: .top) {
                    Image(systemName: "chevron.backward")
                    Text("Back").foregroundColor(.blue)
                }.foregroundColor(.blue)
            })
        }
    }
    
    func details() -> some View {
        List {
            MovieDetailCellView(property: ("Title", [self.movie.title ?? ""]))
            
            Group {
                MovieDetailCellView(property: ("Genre", [self.movie.genre ?? ""]))
                MovieDetailCellView(property: ("Rating", [self.movie.rating ?? ""]))
                MovieDetailCellView(property: ("Date", [(self.movie.date?.formatted()) ?? ""]))
                MovieDetailCellView(property: ("Duration", [self.movie.runtime ?? ""]))
            }

            Group {
                MovieDetailCellView(property: ("Description", [self.movie.movieDescription ?? ""]))
            }
            
            Group {
                MovieDetailCellView(property: ("Director", [self.movie.director ?? ""]))
                MovieDetailCellView(property: ("Actors", [self.movie.actors ?? ""]))
                MovieDetailCellView(property: ("Created", [self.movie.created?.formatted() ?? ""]))
                MovieDetailCellView(property: ("Year", [self.movie.year ?? ""]))
            }
            
            HStack {
                Text("Website URL")
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.secondary)
                Spacer().frame(width: 20)
                VStack {
                    if let url = self.movie.link {
                        Link("More Information", destination: url)
                            .foregroundColor(.blue)
                    }
                }.frame(maxWidth: .infinity, alignment: .leading)
            }.font(.caption)
        }
    }
}

struct MovieDetailedView_Previews: PreviewProvider {
    
    static var movie = Movie(id: 1, actors: "Mark Wahlberg, Sophie Cookson", cover: URL(string: "https://m.media-amazon.com/images/M/MV5BZTU5MmY0ZjctYTNlOS00MDIyLWJkZTAtNzBiOTkyNWI5MGY2XkEyXkFqcGdeQXVyNTc4MjczMTM@._V1_FMjpg_UY720_.jpg"), created: Date(), date: Date(), director: "Antoine Fuqua", genre: "Fantasy", link: URL(string: "https://www.imdb.com/title/tt6654210/?ref_=ttmi_tt"), movieDescription: "A man discovers that his hallucinations are actually visions from past lives.", rating: "5.5/10", runtime: "1h 46m", title: "Infinite", year: "2021")
    
    static var previews: some View {
        MovieDetailedView(movie: movie)
    }
}
