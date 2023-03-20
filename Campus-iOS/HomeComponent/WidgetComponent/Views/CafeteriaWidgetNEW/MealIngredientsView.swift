//
//  MealIngredientsView.swift
//  Campus-iOS
//
//  Created by Timothy Summers on 20.02.23.
//

import SwiftUI

struct MealIngredientsView: View {
    
    var mealTitle: String
    var labels: [String]
    var price: String
    @State private var showingAlert = false
    
    var body: some View {
        Image(systemName: "info.circle")
            .foregroundColor(Color.highlightText)
            .frame(width: 5)
            .onTapGesture {
                showingAlert.toggle()
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text(mealTitle), message: Text("\(labels.joined(separator: "\n"))\n\n\(price)"), dismissButton: .default(Text("Got it!")))
            }
    }
}
