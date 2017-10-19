//
//  LectureDetailsManager.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 1/17/16.
//  Copyright © 2016 LS1 TUM. All rights reserved.
//

import SWXMLHash
import Sweeft

final class LectureDetailsManager: DetailsManager {
    
    typealias DataType = Lecture
    
    var config: Config
    
    init(config: Config) {
        self.config = config
    }
    
    func fetch(for data: Lecture) -> Promise<Lecture, APIError> {
        guard !data.detailsLoaded else {
            return .successful(with: data)
        }
        return config.tumOnline.doXMLObjectsRequest(to: .lectureDetails,
                                                    queries: ["pLVNr" : data.id],
                                                    at: "rowset", "row").map { (xml: [XMLIndexer]) in
        
            data.detailsLoaded = true
            guard let lecture = xml.first else {
                return data
            }
            let details = [
                ("Methods", lecture["lehrmethode"].element?.text),
                ("Content", lecture["lehrinhalt"].element?.text),
                ("Goal", lecture["lehrziel"].element?.text),
                ("Language", lecture["haupt_unterrichtssprache"].element?.text),
                ("First Appointment", lecture["ersttermin"].element?.text)
            ] ==> iff
            data.details.append(contentsOf: details)
            return data
        }
    }
    
}
