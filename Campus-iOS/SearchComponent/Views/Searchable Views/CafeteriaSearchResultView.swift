//
//  CafeteriaSearchResultView.swift
//  Campus-iOS
//
//  Created by David Lin on 27.12.22.
//

import SwiftUI

struct CafeteriasSearchResultView: View {
    @StateObject var vm: CafeteriasSearchResultViewModel
    @Binding var query: String
    
    var body: some View {
        ZStack {
            Color.white
            ScrollView {
                ForEach(vm.results, id: \.0) { result in
                    VStack {
                        Text(result.cafeteria.name).foregroundColor(.indigo)
                        Text(result.cafeteria.location.address).foregroundColor(.teal)
                        Text(String(result.cafeteria.queue?.percent ?? 0.0)).foregroundColor(.purple)
                    }
                }
            }
        }
        .onChange(of: query) { newQuery in
            print(query)
            Task {
                await vm.cafeteriasSearch(for: newQuery)
            }
        }
    }
}
