//
//  PlaceDetailVM.swift
//  Nearby
//
//  Created by Kuliza-241 on 5/25/18.
//  Copyright © 2018 Abhisek. All rights reserved.
//

import Foundation
import CoreLocation

class PlaceDetailVM {
    
    // MARK: Output
    var title = ""
    var location: CLLocation? = nil
    var distance = ""
    var openStatus = ""
    
    private var place: NearbyPlace!
    
    init(place: NearbyPlace) {
        self.place = place
        configureOutput()
    }
    
    private func configureOutput() {
        title = place.name ?? ""
        let openStat = place.openStatus ?? false
        openStatus = openStat ? "Open" : "Close"
        location = place.location
        let currentLocation = CLLocation(latitude: LocationManager.sharedManager.latitude, longitude: LocationManager.sharedManager.longitude)
        guard let distance = place.location?.distance(from: currentLocation) else { return }
        self.distance = String(format: "%.2f mi", distance/1609.344)
    }
    
}
