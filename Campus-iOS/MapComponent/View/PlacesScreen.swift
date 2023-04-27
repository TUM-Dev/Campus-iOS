//
//  PlacesScreen.swift
//  Campus-iOS
//
//  Created by Timothy Summers on 25.04.23.
//

import SwiftUI

struct PlacesScreen: View {
    
    @StateObject var vm: MapViewModel

    init(vm: MapViewModel) {
        self._vm = StateObject(wrappedValue: vm)
    }
    
    var body: some View {
        PlacesView(vm: self.vm)
            .padding(.top, 60)
    }
}
