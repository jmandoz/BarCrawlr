//
//  CustomAnnotaion.swift
//  BarCrawlr
//
//  Created by Jason Mandozzi on 8/8/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import Foundation
import MapKit

class customPin: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
}
