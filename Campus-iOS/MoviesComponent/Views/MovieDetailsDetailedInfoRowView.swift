//
//  MovieDetailsDetailedInfoRowView.swift
//  Campus-iOS
//
//  Created by Atharva Mathapati on 29.06.22.
//

import SwiftUI

struct MovieDetailsDetailedInfoRowView: View {
    var title: String
    var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
            
            Text(text)
                .font(.system(size: 16))
        }
    }
}

struct MovieDetailsDetailedInfoRowView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailsDetailedInfoRowView(
            title: "number",
            text: "test"
        )
    }
}
