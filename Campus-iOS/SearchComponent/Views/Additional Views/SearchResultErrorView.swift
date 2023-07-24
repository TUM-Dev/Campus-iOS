//
//  SearchResultErrorView.swift
//  Campus-iOS
//
//  Created by David Lin on 07.03.23.
//

import SwiftUI

struct SearchResultErrorView: View {
    @State var title: String
    @State var error: String
    
    var body: some View {
        ZStack {
            Color.white
            VStack {
                HStack {
                    Image(systemName: "exclamationmark.triangle")
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
                Text("Error searching: \(error)")
            }
        }
    }
}

struct SearchResultErrorView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultErrorView(title: "Grades", error: "No internet connection.")
    }
}
