//
//  Toolbar.swift
//  Campus-iOS
//
//  Created by ghjtd hbmu on 23.01.22.
//

import SwiftUI

struct Toolbar: View {
    @StateObject var vm: MapViewModel
    
    var body: some View {
        if vm.selectedCafeteriaName != "" {
            HStack {
                Button(action: {
                    print(vm.selectedCafeteria.name)
                    let latitude = vm.selectedCafeteria.location.latitude
                    let longitude = vm.selectedCafeteria.location.longitude
                    let url = URL(string: "maps://?saddr=&daddr=\(latitude),\(longitude)")
                    
                    if UIApplication.shared.canOpenURL(url!) {
                          UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                    }
                }) {
                    Image(systemName: "figure.walk").foregroundColor(Color.black)
                }
                
                Divider().frame(width: 15)
                
                NavigationLink(destination: MealPlanView(viewModel: MealPlanViewModel(cafeteria: vm.selectedCafeteria))) { Image(systemName: "doc.text").foregroundColor(Color.black) }
            }
            .mask(Rectangle())
            .frame(width: 100, height: 40)
            .background()
            .cornerRadius(10.0)
            .position(x: 8 * UIScreen.main.bounds.width/10, y: 1.2 * UIScreen.main.bounds.height/10)
        }
    }
}

/*struct Toolbar_Previews: PreviewProvider {
    static var previews: some View {
        Toolbar()
    }
}*/
