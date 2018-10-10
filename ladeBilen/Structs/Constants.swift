//
//  Constants.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 21.12.2017.
//  Copyright © 2017 Ludvig Ellevold. All rights reserved.
//

import Foundation
import UIKit
import Firebase

struct Constants {
    static let SCREEN_WIDTH = UIScreen.main.bounds.width
    static let SCREEN_HEIGHT = UIScreen.main.bounds.height
    
    static let VIBRATION_WEAK: UInt32 = 1519
    static let VIBRATION_STRONG: UInt32 = 1520
    static let VIBRATION_ERROR: UInt32 = 1521
    
    struct PATHS {
        static let USER_CACHE_PATH: String = Auth.auth().currentUser!.uid + ".json"
        static let STATION_CACHE_PATH: String = "stations.json"
        static let FILTERED_STATION_CACHE: String = Auth.auth().currentUser!.uid + "_stations.json"
            //Auth.auth().currentUser!.uid + "_stations.json"
        static let CONNECTOR_DESCRIPTION_PATH: String = Auth.auth().currentUser!.uid + "_connectorDescriptions.json"
    }
    
}
