//
//  TUMSexyView.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 13.01.22.
//

import SwiftUI

struct TUMSexyView: View {
    
    @ObservedObject var viewModel = TUMSexyViewModel()
    @AppStorage("useBuildInWebView") var useBuildInWebView: Bool = true
    @State var isWebViewShowed = false
    @State private var searchText = ""
    
    var body: some View {
        List(searchResults.indices , id: \.self) { idx in
            if useBuildInWebView {
                Text(searchResults[idx].description ?? "")
                    .foregroundColor(.blue)
                    .onTapGesture {
                        isWebViewShowed.toggle()
                    }
                    .sheet(isPresented: $isWebViewShowed, content: {
                        SFSafariViewWrapper(url: URL(string: searchResults[idx].target ?? "")!)
                    })
                    .accessibilityLabel("List element" + "\(idx + 1)" + " of " + "\(searchResults.count)")
                    .accessibilityHint("This Button opens a WebView")
            } else {
                Link(searchResults[idx].description ?? "", destination: URL(string: searchResults[idx].target ?? "")!)
                    .accessibilityLabel("List element" + "\(idx + 1)" + " of " + "\(searchResults.count)")
                    .accessibilityHint("This Link leaves the App")
            }
        }
        .searchable(text: $searchText)
        .navigationTitle("Useful Links")
        .accessibilityLabel("This is a list with " + "\(searchResults.count)" + " entries")
    }
    
    var searchResults: [TUMSexyLink] {
        if searchText.isEmpty {
            return viewModel.links
        } else {
            return viewModel.links.filter { $0.description!.localizedLowercase.contains(searchText.localizedLowercase) }
        }
    }
}

struct TUMSexyView_Previews: PreviewProvider {
    static var previews: some View {
        TUMSexyView()
    }
}
