//
//  MealPlanView.swift
//  Campus-iOS
//
//  Created by August Wittgenstein on 09.01.22.
//

import SwiftUI
import Alamofire

struct MealPlanView: View {
    @State var canteen: Cafeteria?
    @State var menus: [Menu] = []
    
    let endpoint = EatAPI.canteens
    let sessionManager = Session.defaultSession
    
    let dateFormatter = DateFormatter()
        
    var body: some View {
        VStack {
            List {
                ForEach(menus, id: \.self) { item in
                    HStack {
                        Text(dateFormatter.string(from: item.date!))
                        Spacer()
                        NavigationLink(destination: MenuView(title: dateFormatter.string(from: item.date!), menu: item)) { EmptyView() }
                        .frame(width: 0, height: 0, alignment: .leading)
                        Spacer().frame(width: 10)
                    }
                }
            }
            .navigationTitle(canteen!.name)
            .onAppear {
                dateFormatter.dateFormat = "EEEE, dd.MM.yyyy"
                fetch()
            }
        }
    }
    
    func fetch() {
        guard let cafeteria = canteen else { return }
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        decoder.dateDecodingStrategy = .formatted(formatter)
        menus.removeAll()
        let thisWeekEndpoint = EatAPI.menu(location: cafeteria.id, year: Date().year, week: Date().weekOfYear)
        sessionManager.request(thisWeekEndpoint).responseDecodable(of: MealPlan.self, decoder: decoder) { [self] response in
            guard let value = response.value else { return }
            menus.append(contentsOf: value.days.filter({ !$0.dishes.isEmpty && ($0.date?.isToday ?? false || $0.date?.isLaterThanOrEqual(to: Date()) ?? false) }))
            menus.sort(by: <)
            print("MenuCount: ", menus.count)
        }
        
        let calendar = Calendar.current
        guard let nextWeek = calendar.date(byAdding: .weekOfYear, value: 1, to: Date()) else { return }
        let nextWeekEndpoint = EatAPI.menu(location: cafeteria.id, year: nextWeek.year, week: nextWeek.weekOfYear)
        sessionManager.request(nextWeekEndpoint).responseDecodable(of: MealPlan.self, decoder: decoder) { [self] response in
            guard let value = response.value else { return }
            menus.append(contentsOf: value.days.filter({ !$0.dishes.isEmpty && ($0.date?.isToday ?? false || $0.date?.isLaterThanOrEqual(to: Date()) ?? false) }))
            menus.sort(by: <)
        }
    }
}

/*struct MealPlanView_Previews: PreviewProvider {
    static var previews: some View {
        MealPlanView(canteen: .constant())
    }
}*/
