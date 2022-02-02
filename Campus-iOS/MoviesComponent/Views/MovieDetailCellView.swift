//
//  MovieDetailCellView.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 27.01.22.
//

import SwiftUI

struct MovieDetailCellView: View {
    var property: (key: LocalizedStringKey, value: [String])
        
    var body: some View {
        HStack {
            Text(property.key)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            Spacer().frame(width: 20)
            VStack(alignment: .leading) {
                ForEach(property.value, id: \.self) { propVal in
                    Text(propVal)
                            .multilineTextAlignment(.leading)
                }
            }.frame(maxWidth: .infinity, alignment: .leading)
        }.font(.caption)
        .foregroundColor(.secondary)
    }
}

struct MovieDetailCellView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailCellView(property: ("Description", ["Some Description"]))
            .previewLayout(.sizeThatFits)
    }
}
