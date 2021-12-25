//
//  GroupBoxLabelView.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 24.12.21.
//

import SwiftUI

struct GroupBoxLabelView: View {
    var semester: String
    
    var body: some View {
        HStack {
            Image(systemName: "graduationcap")
                .imageScale(.medium)
            Text(semester)
                .font(.system(size: 18))
        }.foregroundColor(.blue)
    }
}

struct GroupBoxLabelView_Previews: PreviewProvider {
    static var previews: some View {
        GroupBoxLabelView(semester: "Wintersemester 2021/22")
    }
}


