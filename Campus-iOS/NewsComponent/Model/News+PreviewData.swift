//
//  News+PreviewData.swift
//  Campus-iOS
//
//  Created by David Lin on 05.05.23.
//

import Foundation

extension News {
    static let previewData: [News] = [
        News(id: "test", sourceId: 1, date: Date.now, created: Date.now, title: "Testing news 1", link: URL(string: "https://www.tum.de"), imageURL: nil),
        News(id: "test1", sourceId: 1, date: Date.now, created: Date.now, title: "Testing news 2", link: URL(string: "https://www.moodle.tum.de"), imageURL: nil),
        News(id: "test2", sourceId: 1, date: Date.now, created: Date.now, title: "Testing news 3", link: URL(string: "https://www.live.rgb.tum.de"), imageURL: nil)
    ]
}
