//
//  MealPlanView.swift
//  Campus-iOS
//
//  Created by August Wittgenstein on 09.01.22.
//

import SwiftUI
import Alamofire

struct MealPlanScreen: View {
    @StateObject var vm: MealPlanViewModel2
    
    init(cafeteria: Cafeteria) {
        self._vm = StateObject(wrappedValue: MealPlanViewModel2(cafeteria: cafeteria))
    }
    
    var body: some View {
        Group {
            switch vm.state {
            case .success(let menus):
                if let firstMenu = menus.first {
                    VStack {
                        MealPlanView(menus: menus, cafeteria: vm.cafeteria, selectedMenu: firstMenu)                    .refreshable {
                            await vm.getMenus()
                        }
                    }
                }
            case .loading, .na:
                LoadingView(text: "Fetching Menus")
            case .failed(let error):
                FailedView(
                    errorDescription: error.localizedDescription,
                    retryClosure: vm.getMenus
                )
            }
        }.onAppear {
            Task {
                await vm.getMenus()
                print(vm.state)
            }
        }.alert(
            "Error while fetching Menus",
            isPresented: $vm.hasError,
            presenting: vm.state) { detail in
                Button("Retry") {
                    Task {
                        await vm.getMenus(forcedRefresh: true)
                    }
                }
        
                Button("Cancel", role: .cancel) { }
            } message: { detail in
                if case let .failed(error) = detail {
                    if let apiError = error as? EatAPIError {
                        Text(apiError.errorDescription ?? "EatAPI Error")
                    } else {
                        Text(error.localizedDescription)
                    }
                }
            }
    }
}

struct MealPlanView: View {
    @Environment(\.colorScheme) var colorScheme
    let menus: [Menu]
    let cafeteria: Cafeteria
    @State var selectedMenu: Menu
        
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
                    
                        if let menu = selectedMenu {
                            MenuView(menu: menu)
                        } else {
                            Spacer().frame(height: 20)
                            Text("No Menu available today").foregroundColor(colorScheme == .dark ? .init(UIColor.lightGray) : .init(UIColor.darkGray))
                        }
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
