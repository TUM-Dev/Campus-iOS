//
//  PersonSearchResultView.swift
//  Campus-iOS
//
//  Created by David Lin on 14.01.23.
//

import Foundation
import SwiftUI

struct PersonSearchResultView: View {
    @StateObject var vm : PersonSearchResultViewModel
    @Binding var query: String
    
    var body: some View {
        ZStack {
            Color.white
            ScrollView {
                Text("\(vm.results.count)")
                ForEach(vm.results, id: \.id) { result in
                    Text(result.fullName)
                }
            }
        }.onChange(of: query) { newQuery in
            Task {
                await vm.personSearch(for: newQuery)
            }
        }
        .onAppear() {
            Task {
                await vm.personSearch(for: query)
            }
        }
    }
}
