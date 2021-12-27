//
//  GroupBoxLabelView.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 24.12.21.
//

import SwiftUI

struct GroupBoxLabelView: View {
    var iconName: String
    var text: String
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .imageScale(.medium)
            Text(text)
                .font(.system(size: 18))
        }.foregroundColor(.blue)
    }
}

struct GroupBoxLabelView_Previews: PreviewProvider {
    static var previews: some View {
        GroupBoxLabelView(iconName: "graduationcap", text: "Wintersemester 2021/22")
    }
}


