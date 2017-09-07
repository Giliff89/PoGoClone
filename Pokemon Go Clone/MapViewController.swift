//
//  ViewController.swift
//  Pokemon Go Clone
//
//  Created by gina iliff on 9/7/17.
//  Copyright © 2017 gina iliff. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            manager.requestWhenInUseAuthorization()
        }
    }
}

