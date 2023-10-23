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
        Group {
            Label("Cafeterias", systemImage: "fork.knife").titleStyle()
                .padding(.top, 20)
            VStack {
                if !vm.cafeterias.isEmpty {
                    ForEach(vm.cafeterias.indices, id: \.self) { index in
                        CafeteriaView(cafeteria: vm.cafeterias[index], isListItem: true)
                        if (index != vm.cafeterias.count - 1) {
                            Divider().padding(.horizontal)
                        }
                    }
                } else {
                    Text("Resource not found") //no cafeterias
                }
            }.sectionStyle()
        }
    }
}
