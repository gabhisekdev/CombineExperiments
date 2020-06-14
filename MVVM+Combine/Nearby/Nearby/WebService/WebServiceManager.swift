//
//  WebServiceManager.swift
//  Nearby
//
//  Created by Abhisek on 08/01/18.
//  Copyright © 2018 Abhisek. All rights reserved.
//

import UIKit
import Combine

enum NearbyAPIError: LocalizedError {
    case requestNotFormed
    
    var errorDescription: String? {
        switch self {
        case .requestNotFormed: return "Unable to form the request."
        }
    }
}

struct WebServiceConstants {
    static let baseURL = "https://maps.googleapis.com/maps/api/place"
    static let placesAPI = "/nearbysearch/json?"
    static let imageAPI = "/photo?"
}

class WebServiceManager: NSObject {
    
    static let sharedService = WebServiceManager()
        
    enum HTTPMethodType: String {
        case POST = "POST"
        case GET = "GET"
    }
    
    func requestAPI<T: Decodable>(url: String, parameter: [String: AnyObject]? = nil, httpMethodType: HTTPMethodType = .GET) -> AnyPublisher<T, NearbyAPIError> {
        guard let escapedAddress = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed),
            let url = URL(string: escapedAddress) else {
                return Fail(error: NearbyAPIError.requestNotFormed).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethodType.rawValue
        
        if let requestBodyParams = parameter {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: requestBodyParams, options: .prettyPrinted)
            } catch {
                return Fail(error: NearbyAPIError.requestNotFormed).eraseToAnyPublisher()
            }
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.0 }
            .decode(type: T.self, decoder: JSONDecoder())
            .catch { _ in Fail(error: NearbyAPIError.requestNotFormed).eraseToAnyPublisher() }
            .eraseToAnyPublisher()
    }
}
