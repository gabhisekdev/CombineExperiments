//
//  PaginationCellViewModel.swift
//  Nearby
//
//  Created by Abhisek on 14/05/18.
//  Copyright © 2018 Abhisek. All rights reserved.
//

import Foundation
import Combine

class PaginationCellVM {
    private var subscriptions = Set<AnyCancellable>()
    
    // Output
    var numberOfPages = 0
    var title = ""
    
    // Datasource
    private var dataSource = [NearbyPlace]()
    
    // Events
    var placeSelected: AnyPublisher<NearbyPlace, Never> {
        placeSelectedSubject.eraseToAnyPublisher()
    }
    private let placeSelectedSubject = PassthroughSubject<NearbyPlace, Never>()
    
    init(data: [NearbyPlace]) {
        dataSource = data
        configureOutput()
    }
    
    private func configureOutput() {
        numberOfPages = dataSource.count
        title = "Hot picks only for you"
    }
    
    func viewModelForPlaceView(position: Int)->PlaceViewVM {
        let place = dataSource[position]
        let placeViewVM = PlaceViewVM(place: place)
        
        placeViewVM.placesViewSelected
            .sink { [weak self] in
            self?.placeSelectedSubject.send(place)
        }
        .store(in: &subscriptions)
        
        return placeViewVM
    }
    
}
