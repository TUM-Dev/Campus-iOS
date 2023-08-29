//
//  CafeteriasView.swift
//  Campus-iOS
//
//  Created by Timothy Summers on 05.06.23.
//

import SwiftUI

struct CafeteriasListView: View {
    
    @StateObject var vm: AnnotatedMapViewModel
    
    var body: some View {
        if !vm.cafeterias.isEmpty {
            Label("Cafeterias", systemImage: "fork.knife").titleStyle()
                .padding(.top, 20)
            ForEach(vm.cafeterias) { cafeteria in
                CafeteriaView(cafeteria: cafeteria)
                Divider().padding(.horizontal)
            }
        } else {
            EmptyView() //no cafeterias
        }
    }
}
