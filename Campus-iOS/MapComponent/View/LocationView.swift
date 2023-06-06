//
//  LocationView.swift
//  Campus-iOS
//
//  Created by Timothy Summers on 06.06.23.
//

import SwiftUI

struct LocationView: View {
    
    var location: TUMLocation
    
    var body: some View {
        ScrollView {
            VStack {
                Text(location.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(width: Size.cardWidth, alignment: .leading)
                HStack{
                    Spacer()
                    Spacer()
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.primaryBackground)
    }
}
