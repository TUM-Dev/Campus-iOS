//
//  LectureDetailsDetailedInfoRowView.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 26.12.21.
//

import SwiftUI

struct LectureDetailsDetailedInfoRowView: View {
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

struct LectureDetailsDetailedInfoRowView_Previews: PreviewProvider {
    static var previews: some View {
        LectureDetailsDetailedInfoRowView(
            title: "number",
            text: "test"
        )
    }
}
