//
//  MapViewModel.swift
//  Campus-iOS
//
//  Created by Philipp Wenner on 08.03.22.
//

import Foundation
import SwiftUI
import Alamofire

final class MapViewModel: ObservableObject {
    @Published var canteens: [Cafeteria] = []
    @Published var selectedCanteen: Cafeteria?
    @Published var zoomOnUser: Bool = true
    @Published var panelPosition: String = "pushMid"
    @Published var lockPanel: Bool = false
    @Published var selectedCanteenName: String = " "
    @Published var selectedAnnotationIndex: Int = 0
    
    private let endpoint = EatAPI.canteens
    private let sessionManager = Session.defaultSession
    
    func fetchCanteens() {
        sessionManager.request(endpoint).responseDecodable(of: [Cafeteria].self, decoder: JSONDecoder()) { [self] response in
            let cafeterias: [Cafeteria] = response.value ?? []
            
            canteens = cafeterias

            for (index, cafeteria) in canteens.enumerated() {
                if let queue = cafeteria.queueStatusApi  {
                    sessionManager.request(queue, method: .get).responseDecodable(of: Queue.self, decoder: JSONDecoder()){ [self] response in
                        canteens[index].queue = response.value
                    }
                }
            }
        }
    }
}
