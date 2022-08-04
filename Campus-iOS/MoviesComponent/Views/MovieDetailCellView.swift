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
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color("tumBlue"))
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            Spacer().frame(width: 20)
            VStack(alignment: .leading) {
                ForEach(property.value, id: \.self) { propVal in
                    Text(propVal)
                            .font(.system(size: 16))
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

