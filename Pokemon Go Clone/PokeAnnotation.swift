//
//  PokeAnnotation.swift
//  Pokemon Go Clone
//
//  Created by gina iliff on 9/15/17.
//  Copyright © 2017 gina iliff. All rights reserved.
//

import UIKit
import MapKit

class PokeAnnotation : NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var pokemon : Pokemon
    
    init(coord:CLLocationCoordinate2D, pokemon: Pokemon) {
        self.coordinate = coord
        self.pokemon = pokemon
    }

}
