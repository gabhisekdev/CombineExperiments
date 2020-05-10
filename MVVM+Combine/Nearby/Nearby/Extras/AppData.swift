//
//  AppData.swift
//  Nearby
//
//  Created by Abhisek on 15/05/18.
//  Copyright © 2018 Abhisek. All rights reserved.
//

import Foundation

class AppData {
    
    static let sharedData = AppData()
    var allPlaces = [NearbyPlace]()
    
    func resetData() {
        allPlaces.removeAll()
    }
    
}
