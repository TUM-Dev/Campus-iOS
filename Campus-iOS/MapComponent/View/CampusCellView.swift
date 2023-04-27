//
//  CampusCellView.swift
//  Campus-iOS
//
//  Created by Timothy Summers on 25.04.23.
//

import SwiftUI

struct CampusCellView: View {
    let campus: Campus
    
    var body: some View {
        VStack {
            campus.image
                .resizable()
                .scaledToFill()
                .frame(maxHeight: 100)
                .cornerRadius(Radius.regular, corners: [.topLeft, .topRight])
                .clipped()
                .padding([.horizontal,.top], 5)
            
            HStack() {
                Text(campus.rawValue)
                    .fontWeight(.semibold)
                    .foregroundColor(.primaryText)
                Spacer()
                NavigationLink(destination: CampusView()) {
                    Image(systemName: "mappin.circle")
                        .font(.system(size: 20))
                        .foregroundColor(.highlightText)
                }
                .padding(7)
                .cornerRadius(5)
            }
            .padding(12)
        }
        .background(Color.secondaryBackground)
        .cornerRadius(Radius.regular)
        .frame(width: Size.cardWidth)
    }
}
