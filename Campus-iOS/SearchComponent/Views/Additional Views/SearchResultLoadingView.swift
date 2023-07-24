//
//  SearchResultLoadingView.swift
//  Campus-iOS
//
//  Created by David Lin on 07.03.23.
//

import SwiftUI

struct SearchResultLoadingView: View {
    @State var title: String
    
    var body: some View {
        ZStack {
            Color.white
            VStack {
                HStack {
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .fontWeight(.semibold)
                        .font(.title2)
                        .foregroundColor(Color.highlightText)
                    Text(title)
                        .fontWeight(.semibold)
                        .font(.title2)
                        .foregroundColor(Color.highlightText)
                    Spacer()
                }
                Divider()
                LoadingView(text: "Searching...")
            }
        }
    }
}

struct SearchResultLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultLoadingView(title: "Grades")
    }
}
