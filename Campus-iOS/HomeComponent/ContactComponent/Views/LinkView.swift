//
//  LinkView.swift
//  Campus-iOS
//
//  Created by Timothy Summers on 07.01.23.
//

import SwiftUI

struct LinkView: View {
    
    @State var selectedLink: URL? = nil
    
    var body: some View {
        HStack {
            Button (action: {
                self.selectedLink = URL(string: "https://www.moodle.tum.de/my/")
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
                self.selectedLink = URL(string: "https://campus.tum.de/tumonline/ee/ui/ca2/app/desktop/#/login")
            }) {
                Label("TUMonline", systemImage: "globe")
                    .foregroundColor(Color.primaryText)
                    .padding(.vertical, 15)
                    .frame(maxWidth: .infinity)
                    .background(Color.secondaryBackground)
            }
            .clipShape(RoundedRectangle(cornerRadius: Radius.regular))
        }
        .frame(width: Size.cardWidth)
        .sheet(item: $selectedLink) { selectedLink in
            if let link = selectedLink {
                SFSafariViewWrapper(url: link)
            }
        }
    }
}

struct LinkView_Previews: PreviewProvider {
    static var previews: some View {
        LinkView()
    }
}
