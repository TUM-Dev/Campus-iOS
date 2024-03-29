//
//  CafeteriaSearchResultView.swift
//  Campus-iOS
//
//  Created by David Lin on 27.12.22.
//

import SwiftUI

struct CafeteriaSearchResultView: View {
    
    let allResults: [(cafeteria: Cafeteria, distances: Distances)]
    @State var size: ResultSize = .small
    @State var cafeteriaMealPlan: Cafeteria? = nil
    
    var results: [(cafeteria: Cafeteria, distances: Distances)] {
        switch size {
        case .small:
            return Array(allResults.prefix(3))
        case .big:
            return Array(allResults.prefix(10))
        }
    }
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Image(systemName: "fork.knife")
                        .fontWeight(.semibold)
                        .font(.title2)
                        .foregroundColor(Color.highlightText)
                    Text("Cafeterias")
                        .fontWeight(.semibold)
                        .font(.title2)
                        .foregroundColor(Color.highlightText)
                    Spacer()
                    ExpandIcon(size: $size)
                }
                Divider()
            }
            Spacer()
            ScrollView {
                ForEach(self.results, id: \.0) { result in
                    CafeteriaView(cafeteria: result.cafeteria)
                    if results.last != nil {
                        if result != results.last! {
                            Divider()
                        }
                    }
                }
            }
            
        }.sheet(item: $cafeteriaMealPlan, content: { cafeteria in
            NavigationView {
                VStack(alignment: .leading) {
                    MealPlanScreen(cafeteria: cafeteria)
                }
                .navigationBarTitle(Text(cafeteria.title ?? "Current Cafeteria"), displayMode: .inline)
                .navigationBarItems(trailing: Button(action: {
                    cafeteriaMealPlan = nil
                }) {
                    Text("Done").bold()
                })
            }
        })
    }
}
