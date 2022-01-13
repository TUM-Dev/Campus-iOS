//
//  TUMSexyView.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 13.01.22.
//

import SwiftUI

struct TUMSexyView: View {
    
    @ObservedObject var viewModel = TUMSexyViewModel()

    var body: some View {
        List(viewModel.links, id: \.target) { link in
            Link(link.description ?? "", destination: URL(string: link.target ?? "")!)
        }
    }
}

struct TUMSexyView_Previews: PreviewProvider {
    static var previews: some View {
        TUMSexyView()
    }
}
