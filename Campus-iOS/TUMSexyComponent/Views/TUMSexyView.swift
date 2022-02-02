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

    var body: some View {
        List(viewModel.links, id: \.target) { link in
            if(useBuildInWebView) {
                Text(link.description ?? "")
                    .foregroundColor(.blue)
                    .onTapGesture {
                        isWebViewShowed.toggle()
                    }
                    .sheet(isPresented: $isWebViewShowed, content: {
                        SFSafariViewWrapper(url: URL(string: link.target ?? "")!)
                    })
            } else {
                Link(link.description ?? "", destination: URL(string: link.target ?? "")!)
            }
        }
    }
}

struct TUMSexyView_Previews: PreviewProvider {
    static var previews: some View {
        TUMSexyView()
    }
}
