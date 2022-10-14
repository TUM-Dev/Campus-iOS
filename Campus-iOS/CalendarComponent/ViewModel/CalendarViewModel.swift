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
    var state: State = .na
    
    init(model: Model) {
        self.model = model
        fetch()
    }
    
    
    func fetch(callback: @escaping (Result<Bool,Error>) -> Void = {_ in }) {
        if(self.model.isUserAuthenticated) {
            let importer = ImporterType(endpoint: Self.endpoint, predicate: nil, dateDecodingStrategy: .formatted(.yyyyMMddhhmmss))
            DispatchQueue.main.async {
                importer.performFetch(handler: { result in
                    switch result {
                    case .success(let storage):
                        self.events = storage.events?.filter( { $0.status != "CANCEL" } ).sorted(by: {
                            guard let dateOne = $0.startDate, let dateTwo = $1.startDate else {
                                return false
                            }
                            return dateOne > dateTwo
                        }) ?? []
                        
                        if let _ = storage.events {
//                            self.state = .success(data: events)
                            callback(.success(true))
                        } else {
                            callback(.failure(CampusOnlineAPI.Error.noPermission))
                        }
                        
                        print(self.state)
                        
                    case .failure(let error):
                        self.state = .failed(error: error)
                        print(error)
                    }
                })
            }
            
        } else {
            self.events = []
        }
    }
    
    var eventsByDate: [Date? : [CalendarEvent]] {
        let dictionary = Dictionary(grouping: events, by: { $0.startDate })
        return dictionary
    }
}

extension CalendarViewModel {
    enum State {
        case na
        case loading
        case success(data: [CalendarEvent]?)
        case failed(error: Error)
    }
}
