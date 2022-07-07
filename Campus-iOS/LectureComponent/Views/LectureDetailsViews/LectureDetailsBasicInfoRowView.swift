//
//  LectureDetailsBasicInfoRowView.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 26.12.21.
//

import SwiftUI

struct LectureDetailsBasicInfoRowView: View {
    var iconName: String
    var text: String
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Image(systemName: iconName)
                .imageScale(.medium)
                .frame(width: 25, height: 25, alignment: .center)
            Text(text)
                .font(.system(size: 16))
                .multilineTextAlignment(.leading)
        }
    }
}

struct LectureDetailsRowView_Previews: PreviewProvider {
    static var previews: some View {
        LectureDetailsBasicInfoRowView(
            iconName: "number",
            text: "LOOOOOOOOOOOOOOOOOOONG (1234.01.001)"
        )
    }
}
