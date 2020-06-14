//
//  PlaceTableCellVM.swift
//  Nearby
//
//  Created by G Abhisek on 13/06/20.
//  Copyright © 2020 Abhisek. All rights reserved.
//

import Foundation
import Combine

class PlaceTableCellVM {
    private var subscriptions = Set<AnyCancellable>()
    private var place: NearbyPlace!
    
    var placeViewVM: PlaceViewVM!
    var placeSelected: AnyPublisher<NearbyPlace, Never> {
        placeSelectedSubject.eraseToAnyPublisher()
    }
    let placeSelectedSubject = PassthroughSubject<NearbyPlace, Never>()
    
    init(place: NearbyPlace) {
        self.place = place
        preparePlaceViewVM()
    }
    
    private func preparePlaceViewVM() {
        placeViewVM = PlaceViewVM(place: place)
        placeViewVM.placesViewSelected
            .sink { [weak self] in
            guard let self = self else { return }
                self.placeSelectedSubject.send(self.place)
        }
        .store(in: &subscriptions)
    }
}
