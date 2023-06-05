//
//  TUMSexyView.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 13.01.22.
//

import SwiftUI

struct TUMSexyView: View {
    
    let links: [TUMSexyLink]
    
    @AppStorage("useBuildInWebView") var useBuildInWebView: Bool = true
    @State var isWebViewShowed = false
    @State var shownLink: TUMSexyLink? = nil
    @State private var searchText = ""
    
    var body: some View {
        List {
            ForEach(searchResults, id: \.id) { link in
                Group {
                    if useBuildInWebView {
                        Button  {
                            self.shownLink = link
                            isWebViewShowed.toggle()
                        } label: {
                            Text(link.description ?? "")
                        }.foregroundColor(.blue)
                    } else {
                        Link(link.description ?? "", destination: URL(string: link.target ?? "")!)
                    }
                }
                    
//
            }
        }
        .searchable(text: $searchText)
        .navigationTitle("Useful Links")
        .sheet(item: $shownLink) { link in
            if let target = link.target, let url = URL(string: target) {
                SFSafariViewWrapper(url: url)
            }
        }
    }
    
    var searchResults: [TUMSexyLink] {
        if searchText.isEmpty {
            return links
        } else {
            return links.filter { $0.description!.localizedLowercase.contains(searchText.localizedLowercase) }
        }
    }
}

//struct TUMSexyView_Previews: PreviewProvider {
//    static var previews: some View {
//        TUMSexyView()
//    }
//}
