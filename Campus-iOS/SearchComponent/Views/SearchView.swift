//
//  SearchView.swift
//  Campus-iOS
//
//  Created by David Lin on 27.12.22.
//

import SwiftUI

struct SearchView<Content: View> : View {
    
    @ObservedObject var model: Model
    @Binding var query: String
    @Environment(\.isSearching) var isSearching
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        if isSearching {
            SearchResultView(vm: SearchResultViewModel(model: self.model))
        } else {
            content()
        }
    }
}
