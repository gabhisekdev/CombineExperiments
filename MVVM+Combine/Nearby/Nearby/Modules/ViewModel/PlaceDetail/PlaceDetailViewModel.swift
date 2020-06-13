//
//  PlaceDetailViewModel.swift
//  Nearby
//
//  Created by Abhisek on 5/23/18.
//  Copyright © 2018 Abhisek. All rights reserved.
//

import Foundation
import CoreLocation
import Combine
import MapKit

class PlaceDetailViewModel {
    // MARK: Output
    @Published private(set) var title = ""
    @Published private(set) var distance = ""
    @Published private(set) var openStatus = ""
    
    let location = CurrentValueSubject<CLLocation?, Never>(nil)
    
    private var place: NearbyPlace!
    
    init(place: NearbyPlace) {
        self.place = place
        configureOutput()
    }
    
    private func configureOutput() {
        title = place.name
        let openStat = place.openStatus ?? false
        openStatus = openStat ? "Open" : "Close"
        location.value = place.location
        
        let currentLocation = CLLocation(latitude: LocationManager.sharedManager.latitude, longitude: LocationManager.sharedManager.longitude)
        guard let distance = place.location?.distance(from: currentLocation) else { return }
        self.distance = String(format: "%.2f mi", distance/1609.344)
    }
}
