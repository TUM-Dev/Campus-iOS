//
//  LoadingView.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 21.12.21.
//

import SwiftUI

struct FailedView: View {
    let errorDescription: String
    
    var body: some View {
        Text("Error! - \(errorDescription)")
    }
}

struct FailedView_Previews: PreviewProvider {
    static var previews: some View {
        FailedView(errorDescription: "Network not present")
    }
}
