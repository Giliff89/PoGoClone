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
    var updateCount = 0
    
    var pokemons : [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pokemons = getAllPokemon()
        
        manager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
            manager.startUpdatingLocation()
        } else {
            manager.requestWhenInUseAuthorization()
        }
        
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { (timer) in
            if let center = self.manager.location?.coordinate {
                let anno = MKPointAnnotation()
                var annoCoord = center
                annoCoord.latitude += (Double(arc4random_uniform(200)) - 100.0) / 50000.0
                annoCoord.longitude += (Double(arc4random_uniform(200)) - 100.0) / 50000.0
                anno.coordinate = annoCoord
                self.mapView.addAnnotation(anno)
            }
        }
    }
    
    // Set how zoomed in you want the map to be with this function (in meters)
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if updateCount < 3 {
            if let center = manager.location?.coordinate {
                let region = MKCoordinateRegionMakeWithDistance(center, 300, 300)
                mapView.setRegion(region, animated: false)
            }
            updateCount += 1
        } else {
            manager.stopUpdatingLocation()
        }
    }
    
    @IBAction func compassTapped(_ sender: Any) {
        if let center = manager.location?.coordinate {
            let region = MKCoordinateRegionMakeWithDistance(center, 300, 300)
            mapView.setRegion(region, animated: true)
        }
    }
}

