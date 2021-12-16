//
//  PanelContent.swift
//  Campus-iOS
//
//  Created by August Wittgenstein on 16.12.21.
//

import SwiftUI

struct PanelContent: View {
    private let handleThickness = CGFloat(0)
    
    let abc = ["a", "b", "c", "d"]
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: handleThickness / 2.0)
                .frame(width: .infinity, height: handleThickness)
                .foregroundColor(Color.secondary)
                .padding(5)
            List {
                ForEach(abc, id: \.self) { item in
                    Text(item)
                }
            }
            .offset(y: 50)
            .listStyle(PlainListStyle())
        }
    }
    
    func createList() {
    }
}

struct PanelContent_Previews: PreviewProvider {
    static var previews: some View {
        PanelContent()
    }
}
