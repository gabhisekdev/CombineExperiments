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
    @Published private(set) var isOpen = false
    @Published private(set) var placeImageUrl: String = ""
    @Published private(set) var location: CLLocation? = nil
    
    private let place: NearbyPlace
    
    init(place: NearbyPlace) {
        self.place = place
        configureOutput()
    }
    
    private func configureOutput() {
        title = place.name
        let openStat = place.openStatus ?? false
        isOpen = openStat
        location = place.location
        placeImageUrl = place.imageURL ?? ""
        
        let currentLocation = CLLocation(latitude: LocationManager.sharedManager.latitude, longitude: LocationManager.sharedManager.longitude)
        guard let distance = place.location?.distance(from: currentLocation) else { return }
        self.distance = String(format: "%.2f mi", distance/1609.344)
    }
}

extension Bool {
    var openStatusText: String {
        self ? "Open" : "Close"
    }
}
