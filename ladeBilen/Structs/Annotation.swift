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
    var realtime: Bool?
    var fastcharge: Bool?
    
    init(title: String, subtitle: String, id: Int, coordinate: CLLocationCoordinate2D, realtime: Bool, fastcharge: Bool) {
        self.title = title
        self.subtitle = subtitle
        self.id = id
        self.coordinate = coordinate
        self.realtime = realtime
        self.fastcharge = fastcharge
    }
}

extension MKPinAnnotationView {
    class func bluePinColor() -> UIColor {
        return UIColor.yellow
    }
    class func redPinColor() -> UIColor {
        return UIColor.red
    }
}

