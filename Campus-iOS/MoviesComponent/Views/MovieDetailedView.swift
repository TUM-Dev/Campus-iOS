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
    @State var navigationBarHidden: Bool = true

    var movie: Movie
    
    var body: some View {
        ScrollView {
            GeometryReader { geometry in
                if let link = self.movie.cover {
                    AsyncImage(url: link) { image in
                        switch image {
                        case .empty:
                            ProgressView()
                                .frame(width: geometry.size.width, height: geometry.size.height)

                        case .success(let image):
                            if geometry.frame(in: .global).minY <= 0 {
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: geometry.size.width, height: geometry.size.height)
                                    .offset(y: geometry.frame(in: .global).minY/9)
                                    .clipped()
                            } else {
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: geometry.size.width, height: geometry.size.height + geometry.frame(in: .global).minY)
                                    .clipped()
                                    .offset(y: -geometry.frame(in: .global).minY)
                            }
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
            }.frame(height: 550)
            .edgesIgnoringSafeArea(.bottom)
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .navigationBarItems(leading: Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
                HStack(alignment: .top) {
                    Image(systemName: "chevron.backward")
                    Text("Back").foregroundColor(.blue)
                }.foregroundColor(.blue)
            })
            .navigationBarTitle(movie.title!, displayMode: .inline)

        
//        VStack(alignment: .center) {
//        }.edgesIgnoringSafeArea(.bottom)
//        .navigationBarBackButtonHidden(true)
//        .navigationBarItems(leading: Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
//            HStack(alignment: .top) {
//                Image(systemName: "chevron.backward")
//                Text("Back").foregroundColor(.blue)
//            }.foregroundColor(.blue)
//        })
            
            VStack(alignment: .leading, spacing: 20) {
                MovieDetailsBasicInfoView(movieDetails: movie)
            }.frame(
                maxWidth: .infinity,
                alignment: .topLeading
            )
            .padding(.horizontal)
                
            VStack(alignment: .leading, spacing: 20) {
                MovieDetailsDetailedInfoView(movieDetails: movie)
            }.frame(
                maxWidth: .infinity,
                alignment: .topLeading
            )
            .padding(.horizontal)
                    
        }.edgesIgnoringSafeArea(.top)
        .gesture(DragGesture().onChanged { _ in
            self.navigationBarHidden = false
        })
        .navigationBarHidden(navigationBarHidden)
    }
    
    // TODO: remove when ready OR update accordingly
    func details() -> some View {
        List {
            VStack(alignment: .leading, spacing: 20) {
                MovieDetailsBasicInfoView(movieDetails: movie)
            }
            VStack(alignment: .leading, spacing: 20) {
                MovieDetailsDetailedInfoView(movieDetails: movie)
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
