//
//  GradesScreen.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 21.12.21.
//

import SwiftUI
import SwiftUICharts

@available(iOS 16.0, *)
struct GradesScreen: View {
    @StateObject var vm: GradesViewModel
    @Binding var refresh: Bool
    
    init(model: Model, refresh: Binding<Bool>) {
        self._vm = StateObject(wrappedValue:
                                GradesViewModel(
                                    model: model,
                                    gradesService: GradesService(),
                                    averageGradesService: AverageGradesService()
                                )
        )
        
        self._refresh = refresh
    }
    
    var body: some View {
        Group {
            switch vm.state {
            case .success(_):
                VStack {
                    GradesView(
                        vm: self.vm
                    )
                    .padding(.top, 30)
                    .refreshable {
                        await vm.reloadGradesAndAverageGrades(forcedRefresh: true)
                    }
                }
    }
}

@available(iOS 16.0, *)
struct GradesScreen_Previews: PreviewProvider {
    static var previews: some View {
        GradesScreen(model: MockModel(), refresh: .constant(false))
    }
}
