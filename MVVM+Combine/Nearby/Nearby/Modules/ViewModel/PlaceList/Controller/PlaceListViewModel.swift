//
//  PlaceListVM.swift
//  Nearby
//
//  Created by Abhisek on 5/23/18.
//  Copyright © 2018 Abhisek. All rights reserved.
//

import Foundation
import Combine

class PlaceListViewModel {
    private var subscriptions = Set<AnyCancellable>()
    // Output
    var numberOfRows = 0
    var title = ""
    
    private let placeType: PlaceType
    private var dataSource = [PlaceTableCellVM]()
    
    // Event
    var placeSelected: AnyPublisher<NearbyPlace, Never> {
        placeSelectedSubject.eraseToAnyPublisher()
    }
    private let placeSelectedSubject = PassthroughSubject<NearbyPlace, Never>()
    
    init(allPlaces: [NearbyPlace], placeType: PlaceType) {
        self.placeType = placeType
        dataSource = allPlaces.map {  return PlaceTableCellVM(place: $0) }
        configureOutput()
    }
    
    private func configureOutput() {
        title = placeType.displayText
        numberOfRows = dataSource.count
    }
    
    func cellViewModel(indexPath: IndexPath)->PlaceTableCellVM {
        let cellViewModel = dataSource[indexPath.row]
        let placeSelectedCallback: (NearbyPlace) -> Void = { [weak self] place in
            self?.placeSelectedSubject.send(place)
        }
        cellViewModel.placeSelected
            .sink(receiveValue: placeSelectedCallback)
            .store(in: &subscriptions)
        return cellViewModel
    }
    
}
