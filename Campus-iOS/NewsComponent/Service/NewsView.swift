//
//  NewsView.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 20.01.22.
//

import SwiftUI

struct NewsView: View {
    
    @ObservedObject var viewModel = NewsViewModel()
    @AppStorage("useBuildInWebView") var useBuildInWebView: Bool = true
    @State var isWebViewShowed = false
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 20) {
                Text("News are here")
                ForEach(viewModel.newsSources, id: \.id) { source in
                    Text("Item \(source.title ?? "")")
                        .foregroundColor(.white)
                        .frame(width: 200, height: 200)
                        .background(Color.black)
                    ForEach(source.news, id: \.id) { piece in
                        Text("Item \(piece.title ?? "")")
                            .foregroundColor(.white)
                            .font(.largeTitle)
                            .frame(width: 200, height: 200)
                            .background(Color.red)
                    }
                }
            }
        }
    }
}

struct NewsView_Previews: PreviewProvider {
    static var previews: some View {
        NewsView()
    }
}
