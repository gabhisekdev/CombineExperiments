//
//  RestaurantWebServices.swift
//  Nearby
//
//  Created by Abhisek on 04/02/18.
//  Copyright © 2018 Abhisek. All rights reserved.
//

import Foundation
import Combine

struct PlaceWebService {
    func fetchAllPlaceList() -> AnyPublisher<[NearbyPlace], NearbyAPIError> {
        let initialPublisher = fetchPlaceList(placeType: PlaceType.allCases[0])
        let remainder = Array(PlaceType.allCases.dropFirst())
        
        return remainder.reduce(initialPublisher) { combined, placeType in
            return combined
                .merge(with: fetchPlaceList(placeType: placeType))
                .eraseToAnyPublisher()
        }
    }
    
    func fetchPlaceList(placeType: PlaceType) -> AnyPublisher<[NearbyPlace], NearbyAPIError> {
        let userLat = String(format:"%3f", LocationManager.sharedManager.latitude)
        let userLong = String(format:"%3f", LocationManager.sharedManager.longitude)

        let url = WebServiceConstants.baseURL + WebServiceConstants.placesAPI + "location=\(userLat),\(userLong)&radius=1000&type=\(placeType.rawValue)&key=\(googleApiKey)"

        let placeResponsePublisher: AnyPublisher<PlacesResponse, NearbyAPIError> = WebServiceManager.sharedService.requestAPI(url: url)
    
        return placeResponsePublisher.print("\n fetch web service")
            .map { $0.places }
            .eraseToAnyPublisher()
    }
}
