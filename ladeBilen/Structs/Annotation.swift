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
    var subtitle: String?
    var id: Int?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, subtitle: String, id: Int, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.id = id
        self.coordinate = coordinate
    }
}
