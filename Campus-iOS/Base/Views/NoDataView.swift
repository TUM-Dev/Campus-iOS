//
//  TestView.swift
//  Campus-iOS
//
//  Created by Mohanned Kandil on 23.10.2023.
//


import SwiftUI

struct NoDataView: View {
    let description: String
    
    init(description: String) {
        self.description = description;
    }
    
    var body: some View {
        VStack (alignment: .center) {
            Text(description.localized)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct NoDataView_Previews: PreviewProvider {
    static var previews: some View {
        NoDataView(description: "No data")
    }
}
