//
//  ViewController.swift
//  Pokemon Go Clone
//
//  Created by gina iliff on 9/7/17.
//  Copyright © 2017 gina iliff. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var manager = CLLocationManager()
    var updateCount = 0
    
    var pokemons : [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pokemons = getAllPokemon()
        
        manager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            setUp()
        } else {
            manager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            setUp()
        }
    }
    
    func setUp() {
        mapView.showsUserLocation = true
        manager.startUpdatingLocation()
        mapView.delegate = self
        
        Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { (timer) in
            if let center = self.manager.location?.coordinate {
                var annoCoord = center
                annoCoord.latitude += (Double(arc4random_uniform(200)) - 100.0) / 50000.0
                annoCoord.longitude += (Double(arc4random_uniform(200)) - 100.0) / 50000.0
                
                let randomIndex = Int(arc4random_uniform(UInt32(self.pokemons.count)))
                
                let randomPokemon = self.pokemons[randomIndex]
                
                let anno = PokeAnnotation(coord: annoCoord, pokemon: randomPokemon)
                self.mapView.addAnnotation(anno)
            }
        }
    }
    
    // Sets the image that pops up on the map to be an image of a pokemon
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annoView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        
        if annotation is MKUserLocation {
            annoView.image = UIImage(named: "player-1")
            var frame = annoView.frame
            frame.size.height = 40
            frame.size.width = 40
            annoView.frame = frame
        } else {
            if let pokeAnnotation = annotation as? PokeAnnotation {
                if let imageName = pokeAnnotation.pokemon.imageName {
                    annoView.image = UIImage(named: imageName)
                    var frame = annoView.frame
                    frame.size.height = 40
                    frame.size.width = 40
                    annoView.frame = frame
                }
            }
        }
        return annoView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation, animated: true)
        
        if view.annotation is MKUserLocation {
            // trainer should not do anything
        } else {
            if let center = manager.location?.coordinate {
                if let pokemonCenter = view.annotation?.coordinate {
                    
                    let region = MKCoordinateRegionMakeWithDistance(pokemonCenter, 200, 200)
                    mapView.setRegion(region, animated: false)
                    
                    if MKMapRectContainsPoint(mapView.visibleMapRect, MKMapPointForCoordinate(center)) {
                        if let pokeAnnotation = view.annotation as? PokeAnnotation {
                            pokeAnnotation.pokemon.caught = true
                            if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                                try? context.save()
                                
                                if let name = pokeAnnotation.pokemon.name {
                                    let alertVC = UIAlertController(title: "Congrats!", message: "You caught a \(name)", preferredStyle: .alert)
                                    
                                    let pokedexAction = UIAlertAction(title: "Pokedex", style: .default, handler: { (action) in
                                        self.performSegue(withIdentifier: "moveToPokedex", sender: nil)
                                    })
                                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (alert) in
                                        alertVC.dismiss(animated: true, completion: nil)
                                    })
                                    alertVC.addAction(pokedexAction)
                                    alertVC.addAction(okAction)
                                    present(alertVC, animated: true, completion: nil)
                                }
                            }
                        }
                    } else {
                        if let pokeAnnotation = view.annotation as? PokeAnnotation {
                            if let name = pokeAnnotation.pokemon.name {
                                let alertVC = UIAlertController(title: "Uh oh!", message: "You are too far away to catch the \(name)", preferredStyle: .alert)
                                let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (alert) in
                                    alertVC.dismiss(animated: true, completion: nil)
                                })
                                alertVC.addAction(okAction)
                                present(alertVC, animated: true, completion: nil)
                            }
                        }
                    }
                }
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

