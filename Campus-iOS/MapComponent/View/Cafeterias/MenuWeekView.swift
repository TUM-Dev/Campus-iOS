//
//  MenuViewWeek.swift
//  Campus-iOS
//
//  Created by Timothy Summers on 30.04.23.
//

import SwiftUI

struct MenuWeekView: View {
    
    let menus: [cafeteriaMenu]
    @State var selectedMenu: cafeteriaMenu
    
    var body: some View {
        VStack {
            HStack{
                if self.menus.count > 0 {
                    VStack{
                        HStack{
                            ForEach(self.menus.prefix(7), id: \.id){ menu in
                                Button(action: {
                                    self.selectedMenu = menu
                                }){
                                    VStack{
                                        Circle()
                                            .fill(menu === self.selectedMenu ?
                                                  (Calendar.current.isDateInToday(menu.date) ? Color("tumBlue") : Color(UIColor.label)) : Color.clear)
                                            .aspectRatio(contentMode: .fit)
                                            .overlay(
                                                Text(getFormattedDate(date: menu.date, format: "d"))
                                                    .fontWeight(.semibold).fixedSize()
                                                    .foregroundColor(menu === self.selectedMenu ? Color(UIColor.systemBackground) : (Calendar.current.isDateInToday(menu.date) ? Color("tumBlue") : Color(UIColor.label)))
                                            )
                                            .frame(maxWidth: UIScreen.main.bounds.width, minHeight: 35, maxHeight: 35)
                                        
                                        Text(getFormattedDate(date: menu.date, format: "EEE"))
                                            .foregroundColor(Color(UIColor.label))
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 5)
                        .padding(.top, 5)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(selectedMenu.getDishes().sorted(by: { getTypeLabel(dishType: $0.dishType) > getTypeLabel(dishType: $1.dishType)}), id: \.self) { dish in
                                    DishView2(dish: dish)
                                }
                            }.padding(.horizontal)
                        }
                        
                        
                        
                    }
                } else {
                    Text("No Menus available")
                }
            }
            Spacer(minLength: 0.0)
        }
    }
    
    func getFormattedDate(date: Date, format: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
    func getTypeLabel(dishType: String) -> String {
        switch dishType {
        case "Wok":
            return "🥘"
        case "Pasta":
            return "🍝"
        case "Pizza":
            return "🍕"
        case "Fleisch":
            return "🥩"
        case "Grill":
            return "🍖"
        case "Studitopf":
            return "🍲"
        case "Vegetarisch/fleischlos":
            return "🥗"
        case "Fisch":
            return "🐟"
        case "Suppe":
            return "🍜"
        default:
            return " "
        }
    }
}
