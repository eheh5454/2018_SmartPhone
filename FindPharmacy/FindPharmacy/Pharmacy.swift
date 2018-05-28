//
//  Pharmacy.swift
//  FindPharmacy
//
//  Created by DoHyun on 2018. 5. 28..
//  Copyright © 2018년 DoHyun. All rights reserved.
//

import Foundation
import MapKit
import Contacts

class Pharmacy: NSObject,MKAnnotation{
    let title: String?
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, coordinate: CLLocationCoordinate2D){
        self.title = title
        self.coordinate = coordinate
        
        super.init()
    }
    
}
