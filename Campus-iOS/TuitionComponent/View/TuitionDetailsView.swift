//
//  TuitionDetailsView.swift
//  Campus-iOS
//
//  Created by Robyn Kölle on 24.06.22.
//

import SwiftUI

struct TuitionDetailsView: View {
    
    @State var tuition: Tuition
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 6) {
            Text(self.tuition.semester ?? "")
                .fontWeight(Font.Weight.heavy)
            HStack {
                Text("Deadline")
                Text(self.tuition.deadline ?? Date(), style: .date)
            }
            .font(Font.custom("HelveticaNeue-Bold", size: 16))
            .foregroundColor(Color.gray)
            
            Divider()
                .foregroundColor(Color.gray.opacity(0.3))
                .padding([.leading, .trailing], -12)
            
            HStack(alignment: .center, spacing: 6) {
                Text("Open Amount")
                    .font(Font.system(size: 13))
                    .fontWeight(Font.Weight.heavy)
                
                OpenTuitionAmountView(tuition: tuition)
                    .padding([.top, .bottom], 8)
                Spacer()
            }
        }
    }
}

struct OpenTuitionAmountView: View {
    
    var tuition: Tuition
    
    static let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.currencySymbol = "€ "
        formatter.numberStyle = .currency
        return formatter
    }()
    
    var formattedAmount: String {
        guard let amount = self.tuition.amount else {
            return "n/a"
        }
        return Self.currencyFormatter.string(from: amount) ?? "n/a"
    }
    
    var body: some View {
        HStack {
            Text(self.formattedAmount)
                .font(Font.custom("HelveticaNeue-Medium", size: 14))
                .padding([.leading, .trailing], 10)
                .padding([.top, .bottom], 5)
                .foregroundColor(Color.white)
        }
        .if(self.tuition.isOpenAmount, transformT: {view in
            view.background(.red)
        }, transformF: {view in
            view.background(.green)
        })
            .cornerRadius(7)
    }
}

struct TuitionDetailsView_Previews: PreviewProvider {
    
    static var tuition = Tuition(deadline: Date(), semester: "Winter Semester 2021/2022", semesterID: "22", amount: 0)
    
    static var previews: some View {
        TuitionDetailsView(tuition: tuition)
        TuitionDetailsView(tuition: tuition)
            .preferredColorScheme(.dark)
    }
}
