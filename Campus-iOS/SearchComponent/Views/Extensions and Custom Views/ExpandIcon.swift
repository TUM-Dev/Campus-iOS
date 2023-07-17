//
//  ExpandIcon.swift
//  Campus-iOS
//
//  Created by David Lin on 06.05.23.
//

import SwiftUI

struct ExpandIcon: View {
    @Binding var size: ResultSize
    
    var body: some View {
        HStack(alignment: .center) {
            Spacer()
            Button {
                withAnimation {
                    switch size {
                    case .big:
                        self.size = .small
                    case .small:
                        self.size = .big
                    }
                }
            } label: {
                if self.size == .small {
                    Image(systemName: "arrow.up.left.and.arrow.down.right")
                        .padding()
                } else {
                    Image(systemName: "arrow.down.right.and.arrow.up.left")
                        .padding()
                }
            }
        }
    }
}
