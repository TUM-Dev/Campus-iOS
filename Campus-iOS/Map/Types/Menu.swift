//
//  Menu.swift
//  Campus-iOS
//
//  Created by August Wittgenstein on 17.12.21.
//

import Foundation

struct Menu: Hashable, Decodable {
    /*
     "date": "2020-03-02",
     "dishes": [...]
     */

    let date: Date
    let dishes: [Dish]

    enum CodingKeys: String, CodingKey {
        case date
        case dishes
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.date = try container.decode(Date.self, forKey: .date)
        self.dishes = try container.decode([Dish].self, forKey: .dishes)
    }
<<<<<<< HEAD
}

struct Category: Hashable, Decodable {
    var name: String
    var dishes: [Dish]
    
    enum CodingKeys: String, CodingKey {
        case name
        case dishes
    }
=======
>>>>>>> 01b55bc (Draft some kind of viewmodel (#396))
}

struct Category: Hashable, Decodable {
    var name: String
    var dishes: [Dish]
    
    enum CodingKeys: String, CodingKey {
        case name
        case dishes
    }
}
