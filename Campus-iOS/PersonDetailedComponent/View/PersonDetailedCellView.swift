//
//  SwiftUIView.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 09.02.22.
//

import SwiftUI

struct PersonDetailedCellView: View {
    
    @State var cell: PersonDetailsCell
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(cell.key)
                .foregroundColor(Color(.label))
            Text(cell.value)
                .foregroundColor(.blue)
        }
    }
}

struct PersonDetailedCellView_Previews: PreviewProvider {
    static var previews: some View {
        PersonDetailedCellView(cell: PersonDetailsCell(key: "E-Mail", value: "test@example.com", actionType: PersonDetailsCell.ActionType.mail))
    }
}
