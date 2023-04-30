//
//  CampusView.swift
//  Campus-iOS
//
//  Created by Timothy Summers on 25.04.23.
//

import SwiftUI

struct CampusView: View {
    let campus: Campus
    let cafeterias: [Cafeteria]
    
    var body: some View {
        ScrollView {
            VStack {
                campus.image
                    .resizable()
                    .scaledToFill()
                    .frame(maxHeight: 120)
                    .clipped()
                    .padding([.horizontal,.top], 5)
                    .padding(.bottom, 10)
                Text(campus.rawValue)
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(width: Size.cardWidth, alignment: .leading)
                    .padding(.bottom, 15)
                Label("Food", systemImage: "fork.knife").titleStyle()
                ForEach(cafeterias) { cafeteria in
                    CafeteriaViewNEW(cafeteria: cafeteria)
                    Divider().padding(.horizontal)
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.primaryBackground)
    }
}
