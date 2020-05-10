//
//  PaginationCellViewModel.swift
//  Nearby
//
//  Created by Abhisek on 14/05/18.
//  Copyright © 2018 Abhisek. All rights reserved.
//

import Foundation

class PaginationCellVM {
    
    // Output
    var numberOfPages = 0
    var title = ""
    
    // Datasource
    private var dataSource = [NearbyPlace]()
    
    // Events
    var placeSelected: (NearbyPlace)->()?
    
    init(data: [NearbyPlace], placeSelected: @escaping (NearbyPlace)->()) {
        dataSource = data
        self.placeSelected = placeSelected
        configureOutput()
    }
    
    private func configureOutput() {
        numberOfPages = dataSource.count
        title = "Hot picks only for you"
    }
    
    func viewModelForPlaceView(position: Int)->PlaceViewVM {
        let place = dataSource[position]
        let placeViewVM = PlaceViewVM(place: place)
        placeViewVM.placesViewSelected = { [weak self] in
            self?.placeSelected(place)
        }
        return placeViewVM
    }
    
}
