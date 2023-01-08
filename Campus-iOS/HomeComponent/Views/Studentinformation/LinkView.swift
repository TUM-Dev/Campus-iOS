//
//  LinkView.swift
//  Campus-iOS
//
//  Created by Timothy Summers on 07.01.23.
//

import SwiftUI

struct LinkView: View {
    
    private let moodleUrl = URL(string: "https://www.moodle.tum.de/my/")!
    private let campusUrl = URL(string: "https://campus.tum.de/tumonline/ee/ui/ca2/app/desktop/#/login")!
    
    var body: some View {
        HStack {
            Button (action: {
                UIApplication.shared.open(self.moodleUrl)
            }) {
                Label("Moodle", systemImage: "book.closed")
                    .foregroundColor(Color.primaryText)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(Color.secondaryBackground)
            }
            .clipShape(RoundedRectangle(cornerRadius: Radius.regular))
            Spacer()
            Button (action: {
                UIApplication.shared.open(self.campusUrl)
            }) {
                Label("TUMOnline", systemImage: "globe")
                    .foregroundColor(Color.primaryText)
                    .padding(.vertical, 15)
                    .frame(maxWidth: .infinity)
                    .background(Color.secondaryBackground)
            }
            .clipShape(RoundedRectangle(cornerRadius: Radius.regular))
        }
        .frame(width: UIScreen.main.bounds.size.width * 0.9)
    }
}

struct LinkView_Previews: PreviewProvider {
    static var previews: some View {
        LinkView()
    }
}
