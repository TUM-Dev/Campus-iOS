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
                .font(.headline.bold())
            Text(text)
                .font(.headline.bold())
        }.foregroundColor(Color("tumBlue"))
    }
}

struct GroupBoxLabelView_Previews: PreviewProvider {
    static var previews: some View {
        GroupBoxLabelView(iconName: "graduationcap.fill", text: "Wintersemester 2021/22")
    }
}


