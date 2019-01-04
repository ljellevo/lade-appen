//
//  Checksum.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 05/01/2019.
//  Copyright © 2019 Ludvig Ellevold. All rights reserved.
//

import Foundation

struct Checksum: Codable {
    var value = ""
    
    init(value: String) {
        self.value = value
    }
}
