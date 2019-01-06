//
//  ConnectorDescription.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 06/01/2019.
//  Copyright © 2019 Ludvig Ellevold. All rights reserved.
//

import Foundation

struct ConnectorDescription: Codable {
    var id: Int = -1
    var desc: String = ""
    
    init(id: Int, desc: String) {
        self.id = id
        self.desc = desc
    }
}
