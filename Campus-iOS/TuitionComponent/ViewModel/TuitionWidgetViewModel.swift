//
//  TuitionWidgetViewModel.swift
//  Campus-iOS
//
//  Created by Robyn Kölle on 01.11.22.
//

import Foundation
import SwiftUI

@MainActor
class TuitionWidgetViewModel: ObservableObject {
    
    @Published var tuition: Tuition?
    private var profileVm = ProfileViewModel(model: Model())
    
    func fetch() async {
        profileVm.fetch()
        
        // TODO: find a cleaner way to "await" the Alamofire request.
        while (profileVm.tuition == nil) {
            try? await Task.sleep(nanoseconds: 1_000_000 * 100)
        }
        
        self.tuition = profileVm.tuition
    }
}
