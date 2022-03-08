//
//  MealPlanView.swift
//  Campus-iOS
//
//  Created by August Wittgenstein on 09.01.22.
//

import SwiftUI
import Alamofire

struct MealPlanView: View {
    @ObservedObject var viewModel: MealPlanViewModel
        
    var body: some View {
        HStack{
            if viewModel.menus.count > 0{
                VStack{
                    HStack{
                        ForEach(viewModel.menus.prefix(7), id: \.id){ menu in
                            Button(action: {
                                viewModel.selectedMenu = menu
                            }){
                                VStack{
                                    Circle()
                                        .fill(menu === viewModel.selectedMenu ? Color("tumBlue") : Color.clear)
                                        .aspectRatio(contentMode: .fit)
                                        .overlay(
                                            Text(getFormattedDate(date: menu.date, format: "d"))
                                                .fontWeight(.semibold).fixedSize()
                                                .foregroundColor(menu === viewModel.selectedMenu ? Color.white : Color(UIColor.label))
                                        )
                                        .frame(maxWidth: 50)

                                    Text(getFormattedDate(date: menu.date, format: "EEE"))
                                        .foregroundColor(Color(UIColor.label))
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 5.0)
                
                    if let menu = viewModel.selectedMenu {
                        MenuView(viewModel: menu)
                    }else{
                        Spacer()
                    }
                }
            }else {
                Text("Kein Menü")
            }
        }
        .navigationTitle(viewModel.title)
    }
    
    func getFormattedDate(date: Date, format: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
}

/*struct MealPlanView_Previews: PreviewProvider {
    static var previews: some View {
        MealPlanView(canteen: .constant())
    }
}*/
