//
//  MealPlanView.swift
//  Campus-iOS
//
//  Created by August Wittgenstein on 09.01.22.
//

import SwiftUI
import Alamofire

struct MealPlanView: View {
    @Environment(\.colorScheme) var colorScheme
    let menus: [cafeteriaMenu]
    let cafeteria: Cafeteria
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
                        .padding(.horizontal, 5.0)
                        
                        MenuViewOld(menu: selectedMenu)
                        
                    }
                } else {
                    Text("No Menus available")
                }
            }
            .navigationTitle(cafeteria.title ?? "No Cafeteria Title")
            Spacer(minLength: 0.0)
        }
    }
    
    func getFormattedDate(date: Date, format: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
}

//struct MealPlanView_Previews: PreviewProvider {
//    static var previews: some View {
//        MealPlanView(viewModel: MealPlanViewModel(cafeteria: Cafeteria(location: Location(latitude: 0.0, longitude: 0.0, address: ""),
//                                                                       name: "",
//                                                                       id: "",
//                                                                       queueStatusApi: "")))
//    }
//}
