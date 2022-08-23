//
//  WidgetTitle.swift
//  Campus-iOS
//
//  Created by Robyn Kölle on 05.07.22.
//

import SwiftUI

struct WidgetTitleView: View {
    
    let title: String
    
    var body: some View {
        Text(title)
            .bold()
            .lineLimit(1)
            .frame(maxWidth: .infinity, alignment: .center)
    }
}

struct WidgetTitle_Previews: PreviewProvider {
    static var previews: some View {
        WidgetTitleView(title: "Title")
    }
}
