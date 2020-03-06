//
//  MapClass.swift
//  MyDogwalk
//
//  Created by Putte on 2019-03-01.
//  Copyright © 2019 Putte. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class MapClass: NSObject, MKAnnotation
{
    var title: String?
    var subtitle: String?
    var latitude: Double
    var longitude: Double
    
    var coordinate: CLLocationCoordinate2D
    {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
}
