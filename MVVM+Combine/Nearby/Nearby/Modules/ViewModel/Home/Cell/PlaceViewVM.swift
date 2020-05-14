//
//  PlaceViewVM.swift
//  Nearby
//
//  Created by Abhisek on 14/05/18.
//  Copyright © 2018 Abhisek. All rights reserved.
//

import Foundation
import CoreLocation

protocol PlaceViewRepresentable {
    // Output
    var placeImageUrl: String { get }
    var name: String { get }
    var distance: String { get }
    
    // Input
    func placesViewPressed()
    
    // Event
    var placesViewSelected: () -> () { get }
}


class PlaceViewVM: PlaceViewRepresentable {
    // Output
    var placeImageUrl: String {
        place.imageURL ?? ""
    }
    
    var name: String {
        place.name
    }
    
    let distance: String
    
    // Data Model
    private var place: NearbyPlace!
    
    // Event
    var placesViewSelected: () -> () = { }
    
    init(place: NearbyPlace) {
        self.place = place
        
        let currentLocation = CLLocation(latitude: LocationManager.sharedManager.latitude, longitude: LocationManager.sharedManager.longitude)
        guard let distance = place.location?.distance(from: currentLocation) else {
            self.distance = ""
            return
        }
        self.distance = String(format: "%.2f mi", distance/1609.344)
    }
    
    func placesViewPressed() {
        placesViewSelected()
    }
    
}
