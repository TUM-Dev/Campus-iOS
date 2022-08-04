//
//  CalendarViewModel.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 23.12.21.
//

import Foundation
import XMLCoder

class CalendarViewModel: ObservableObject {
    typealias ImporterType = Importer<CalendarEvent, CalendarAPIResponse, XMLDecoder>
    private static let endpoint = TUMOnlineAPI.calendar

    @Published var events: [CalendarEvent] = []
    
    let model: Model
    
    init(model: Model) {
        self.model = model
        fetch()
    }
    
    func fetch() {
        let importer = ImporterType(endpoint: Self.endpoint, predicate: nil, dateDecodingStrategy: .formatted(.yyyyMMddhhmmss))
        
        importer.performFetch(handler: { result in
            switch result {
            case .success(let storage):
                self.events = storage.events?.filter( { $0.status != "CANCEL" } ).sorted(by: {
                    guard let dateOne = $0.startDate, let dateTwo = $1.startDate else {
                        return false
                    }
                    return dateOne > dateTwo
                }) ?? []
            case .failure(let error):
                print(error)
            }
        })
    }
    
    var eventsByDate: [Date? : [CalendarEvent]] {
        let dictionary = Dictionary(grouping: events, by: { $0.startDate })
        return dictionary
    }
}
