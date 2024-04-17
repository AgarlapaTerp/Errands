//
//  Ollie.swift
//  Errands
//
//  Created by user256510 on 4/16/24.
//

import UIKit
import MapKit

class Ollie: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    
    init(title: String, coordinate: CLLocationCoordinate2D, info: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }
}
