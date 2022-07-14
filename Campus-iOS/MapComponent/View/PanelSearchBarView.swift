//
//  PanelSearchBar.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 22.05.22.
//

import SwiftUI

struct PanelSearchBarView: View {
    @Binding var panelPosition: String
    @Binding var lockPanel: Bool
    @Binding var searchString: String
    
    @State private var isEditing = false
    
    var body: some View {
        TextField("Search ...", text: $searchString, onEditingChanged: { (editingChanged) in
            if editingChanged {
                isEditing = true
                lockPanel = true
                panelPosition = "pushKBTop"
            } else {
                isEditing = false
                lockPanel = false
            }
        })
            .padding(7)
            .background(Color(.systemGray6))
            .cornerRadius(8)

        if isEditing {
            Button(action: {
                isEditing = false
                lockPanel = false
                searchString = ""
                
                withAnimation(.easeInOut(duration: 5)) {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            }) {
                Image(systemName: "xmark.circle")
                    .font(.title2)
                    .foregroundColor(Color(UIColor.tumBlue))
            }
            .padding(.trailing, 10)
            .transition(.move(edge: .trailing))
        }
    }
}


struct PanelSearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        PanelSearchBarView(
            panelPosition: .constant(""),
            lockPanel: .constant(true),
            searchString: .constant("")
        )
    }
}
