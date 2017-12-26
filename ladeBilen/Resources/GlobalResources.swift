//
//  GlobalResources.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 25.12.2017.
//  Copyright © 2017 Ludvig Ellevold. All rights reserved.
//

import Foundation

struct GlobalResources {
    static var user: User?
    static var stations: [Station]?
    
    func setUser(newUser: User){
        GlobalResources.user = newUser
    }
}
