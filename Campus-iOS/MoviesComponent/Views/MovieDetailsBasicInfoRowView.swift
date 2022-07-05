//
//  MovieDetaislBasicInfoRowView.swift
//  Campus-iOS
//
//  Created by Atharva Mathapati on 23.06.22.
//

import SwiftUI

struct MovieDetailsBasicInfoRowView: View {
    var iconName: String
    var text: String

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Image(systemName: iconName)
                .imageScale(.medium)
                .frame(width: 25, height: 25, alignment: .center)
            Text(text)
                .font(.system(size: 16))
        }
    }
}

struct MovieDetaislBasicInfoRowView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailsBasicInfoRowView(
            iconName: "number",
            text: "test"
        )
    }
}

