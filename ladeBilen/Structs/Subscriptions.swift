//
//  Subscriptions.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 29/12/2018.
//  Copyright © 2018 Ludvig Ellevold. All rights reserved.
//

import Foundation

struct Subscription: Codable {
    var id: String = ""
    var from: Int64 = -1
    var to: Int64 = -1
    var update: Int64 = -1

    
    init(values: [String: Int64], key: String) {
        self.id = key
        self.from = values["from"]!
        self.to = values["to"]!
        self.update = values["update"]!
    }
}
