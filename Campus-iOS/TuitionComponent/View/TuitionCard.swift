//
//  TuitionCard.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 08.02.22.
//

import SwiftUI

struct TuitionCard: View {
    
    @State var tuition: Tuition
    
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
        VStack(alignment: .center, spacing: 0) {
            
            ZStack {
                Rectangle().foregroundColor(Color(red: 8/255, green: 100/255, blue: 188/255))
                    .frame(minWidth: nil, idealWidth: nil, maxWidth: UIScreen.main.bounds.width, minHeight: nil, idealHeight: nil, maxHeight: UIScreen.main.bounds.height, alignment: .center)
                    .clipped()
                Image("logo-white")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 175, height: 100, alignment: .center)
            }
            
            // Stack bottom half of card
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
                    Spacer()
                }
                .padding([.top, .bottom], 8)
            }
            .padding(12)
            
        }
        .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.width * 0.8)
        .background(Color(.systemGray6))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.2), radius: 7, x: 0, y: 2)
    }
}

struct TuitionCard_Previews: PreviewProvider {
    
    static var tuition = Tuition(deadline: Date(), semester: "Winter Semester 2021/2022", semesterID: "22", amount: 0)

    static var previews: some View {
        Group {
            TuitionCard(tuition: tuition)
            TuitionCard(tuition: tuition)
                .preferredColorScheme(.dark)
        }
    }
}
