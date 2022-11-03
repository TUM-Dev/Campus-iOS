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
    
    @Published var events: [CalendarEvent]?
    
    let model: Model
    var state: State = .na
    
    init(model: Model) {
        self.model = model
        fetch()
    }
    
    
    func fetch(callback: @escaping (Result<Bool,Error>) -> Void = {_ in }) {
        
        guard self.model.isUserAuthenticated else {
            return
        }
        
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
                        callback(.success(true))
                    } else {
                        callback(.failure(CampusOnlineAPI.Error.noPermission))
                    }
                case .failure(let error):
                    self.state = .failed(error: error)
                }
            })
        }
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

extension Date {
    public var removeTimeStamp : Date? {
       guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: self)) else {
        return nil
       }
       return date
   }
}
