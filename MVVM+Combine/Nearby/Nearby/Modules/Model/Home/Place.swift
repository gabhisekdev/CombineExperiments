//
//  NearbyPlace.swift
//  Nearby
//
//  Created by Abhisek on 13/05/18.
//  Copyright © 2018 Abhisek. All rights reserved.
//

import Foundation
import CoreLocation

enum PlaceType: String, CaseIterable {
    case restaurant = "restaurant"
    case atm = "atm"
    case nightClub = "night_club"
    case cafe = "cafe"
    
    var iconName: String {
        switch self {
        case .restaurant:
            return "restaurant"
        case .atm:
            return "atm"
        case .nightClub:
            return "nightclub"
        case .cafe:
            return "cafe"
        }
    }
    
    var displayText: String {
        switch self {
        case .restaurant:
            return "Restaurant"
        case .atm:
            return "ATM"
        case .nightClub:
            return "Night Club"
        case .cafe:
            return "Cafe"
        }
    }
    
    var homeCellTitleText: String {
        switch self {
        case .restaurant:
            return "Top Restaurants nearby"
        case .atm:
            return "Closest ATMs nearby"
        case .nightClub:
            return "Top Nightclubs nearby"
        case .cafe:
            return "Top Cafes nearby"
        }
    }
    
}

struct PlacesResponse: Decodable {
    let places: [NearbyPlace]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        places = try container.decode([NearbyPlace].self, forKey: CodingKeys.places)
    }
    
    enum CodingKeys: String, CodingKey {
        case places = "results"
    }
}

struct NearbyPlace: Decodable {
    let name: String
    let address: String?
    let geometry: Geometry?
    let type: PlaceType!
    let photos: [Photo]?
    let rating: Double?
    let openStatus: Bool?
    var imageURL: String? {
        guard let photoRef = photos?.first?.photoReference else {
           return nil
        }
        return WebServiceConstants.baseURL + WebServiceConstants.imageAPI + "maxwidth=300&" + "photoreference=\(photoRef)&key=\(googleApiKey)"
    }
    
    var location: CLLocation? {
        guard let lat = geometry?.location.lat,
            let long = geometry?.location.lng else { return nil }
        
        return CLLocation(latitude: lat , longitude: long)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: CodingKeys.name)
        address = try container.decodeIfPresent(String.self, forKey: CodingKeys.address)
        rating = try container.decodeIfPresent(Double.self, forKey: CodingKeys.rating)
        photos = try container.decodeIfPresent([Photo].self, forKey: CodingKeys.photos)
        
        if let openingHourContainer = try? container.nestedContainer(keyedBy: CodingKeys.self, forKey: CodingKeys.openingHours) {
            openStatus = try openingHourContainer.decode(Bool.self, forKey: CodingKeys.openStatus)
        } else {
            openStatus = false
        }
        
        let types = try container.decode([String].self, forKey: CodingKeys.types)
        type = types.compactMap { PlaceType(rawValue: $0) }.first
        
        geometry = try container.decodeIfPresent(Geometry.self, forKey: CodingKeys.geometry)
    }
    
    enum CodingKeys: String, CodingKey {
        case openStatus = "open_now"
        case name, rating, photos, types, geometry
        case openingHours = "opening_hours"
        case address = "vicinity"
    }
}

struct Geometry: Codable {
    let location: Location
    let viewport: Viewport
}

// MARK: - Location
struct Location: Codable {
    let lat, lng: Double
}

// MARK: - Viewport
struct Viewport: Codable {
    let northeast, southwest: Location
}

struct Photo: Codable {
    let height: Int
    let htmlAttributions: [String]
    let photoReference: String
    let width: Int

    enum CodingKeys: String, CodingKey {
        case height, width
        case htmlAttributions = "html_attributions"
        case photoReference = "photo_reference"
    }
}
