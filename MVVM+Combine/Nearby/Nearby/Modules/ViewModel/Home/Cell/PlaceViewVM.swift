//
//  PlaceViewVM.swift
//  Nearby
//
//  Created by Abhisek on 14/05/18.
//  Copyright © 2018 Abhisek. All rights reserved.
//

import Foundation
import CoreLocation
import Combine

protocol PlaceViewRepresentable {
    // Output
    var placeImageUrl: String { get }
    var name: String { get }
    var distance: String { get }
    
    // Input
    var placesViewSelected: AnyPublisher<Void, Never> { get }
}


class PlaceViewVM: PlaceViewRepresentable {
    @Published private(set) var placeImageUrl: String = ""
    @Published private(set) var name: String = ""
    @Published private(set) var distance: String = ""
    
    // Event
    var placesViewSelected: AnyPublisher<Void, Never> {
        placesViewSelectedSubject.eraseToAnyPublisher()
    }
    private let placesViewSelectedSubject = PassthroughSubject<Void, Never>()
    
    init(place: NearbyPlace) {
        placeImageUrl = place.imageURL ?? ""
        name = place.name
        
        let currentLocation = CLLocation(latitude: LocationManager.sharedManager.latitude, longitude: LocationManager.sharedManager.longitude)
        
        if let distance = place.location?.distance(from: currentLocation) {
            self.distance = String(format: "%.2f mi", distance/1609.344)
        }
    }
    
    func placesViewPressed() {
        placesViewSelectedSubject.send(())
    }
    
}
