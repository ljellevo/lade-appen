//
//  Enums.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 14.04.2018.
//  Copyright © 2018 Ludvig Ellevold. All rights reserved.
//

import Foundation

enum elements {
    case InfoElement
    case CommentsElement
    case ConnectorElement
    case ImageElement
}

enum action {
    case cancel
    case favorite
    case subscribe
    case unsubscribe
}

enum popularity {
    case low
    case medium
    case high
}

let connAssetLink = [
    0 : "Unspecified",
    14: "Schuko",
    29: "Tesla",
    30: "CHAdeMO",
    31: "Type 1",
    32: "Type 2",
    34: "3-pin",
    35: "4-pin",
    36: "5-pin",
    39: "CCS",
    40: "Tesla",
    41: "Combo + CHAdeMO",
    50: "Type 2 + Schuko",
    60: "Type1Type2",
]

enum appError: Error {
    case connectionError

}


