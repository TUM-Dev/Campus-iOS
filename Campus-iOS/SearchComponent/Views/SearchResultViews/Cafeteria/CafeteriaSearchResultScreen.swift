//
//  CafeteriaSearchResultScreen.swift
//  Campus-iOS
//
//  Created by David Lin on 07.03.23.
//

import SwiftUI

@MainActor
struct CafeteriaSearchResultScreen: View {
    @StateObject var vm: CafeteriaSearchResultViewModel
    @Binding var query: String
    @State var size: ResultSize = .small
    
    var body: some View {
        Group {
            switch vm.state {
            case .success(let data):
                CafeteriaSearchResultView(allResults: data, size: self.size)
            case .loading, .na:
                SearchResultLoadingView(title: "Cafeterias")
            case .failed(let error):
                SearchResultErrorView(title: "Cafeterias", error: error.localizedDescription)
            }
        }.onChange(of: query) { newQuery in
            Task {
                await vm.cafeteriasSearch(for: newQuery)
            }
        }.task {
            await vm.cafeteriasSearch(for: query)
        }
    }
}

struct CafeteriasSearchResultScreen_Previews: PreviewProvider {
    static var previews: some View {
        CafeteriaSearchResultScreen(vm: CafeteriaSearchResultViewModel(service: CafeteriasService_Preview()), query: .constant("Garching"))
            .cornerRadius(25)
            .padding()
            .shadow(color: .gray.opacity(0.8), radius: 10)
    }
}

struct CafeteriasService_Preview: CafeteriasServiceProtocol {
    func fetch(forcedRefresh: Bool) async throws -> [Cafeteria] {
        return Cafeteria.previewData
    }
}
