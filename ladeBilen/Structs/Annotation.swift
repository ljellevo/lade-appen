//
//  Annotation.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 21.11.2017.
//  Copyright © 2017 Ludvig Ellevold. All rights reserved.
//

import MapKit
import UIKit

class Annotation: NSObject, MKAnnotation {
    var title: String?
    var street: String
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, coordinate: CLLocationCoordinate2D, street: String) {
        self.title = title
        self.coordinate = coordinate
        self.street = street
    }
}
