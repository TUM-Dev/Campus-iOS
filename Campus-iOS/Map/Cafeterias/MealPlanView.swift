//
//  MealPlanView.swift
//  Campus-iOS
//
//  Created by ghjtd hbmu on 09.01.22.
//

import SwiftUI
import Alamofire

struct MealPlanView: View {
    @State var canteen: Cafeteria?
    @State var menus: [Menu]
    
    let endpoint = EatAPI.canteens
    let sessionManager = Session.defaultSession
    
    var body: some View {
        NavigationView {
            List {
            }
        }
        .navigationTitle(canteen!.name)
        .onAppear {
            fetch()
            print(canteen?.name)
        }
    }
    
    func fetch() {
        guard let cafeteria = canteen else { return }
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        decoder.dateDecodingStrategy = .formatted(formatter)
        self.menus.removeAll()
        let thisWeekEndpoint = EatAPI.menu(location: cafeteria.id, year: Date().year, week: Date().weekOfYear)
        sessionManager.request(thisWeekEndpoint).responseDecodable(of: MealPlan.self, decoder: decoder) { [self] response in
            guard let value = response.value else { return }
            self.menus.append(contentsOf: value.days.filter({ !$0.dishes.isEmpty && ($0.date?.isToday ?? false || $0.date?.isLaterThanOrEqual(to: Date()) ?? false) }))
            self.menus.sort(by: <)
        }
        let calendar = Calendar.current
        guard let nextWeek = calendar.date(byAdding: .weekOfYear, value: 1, to: Date()) else { return }
        let nextWeekEndpoint = EatAPI.menu(location: cafeteria.id, year: nextWeek.year, week: nextWeek.weekOfYear)
        self.sessionManager.request(nextWeekEndpoint).responseDecodable(of: MealPlan.self, decoder: decoder) { [self] response in
            guard let value = response.value else { return }
            self.menus.append(contentsOf: value.days.filter({ !$0.dishes.isEmpty && ($0.date?.isToday ?? false || $0.date?.isLaterThanOrEqual(to: Date()) ?? false) }))
            self.menus.sort(by: <)
        }
        
        print(self.menus)
    }
}

/*struct MealPlanView_Previews: PreviewProvider {
    static var previews: some View {
        MealPlanView(canteen: .constant())
    }
}*/
