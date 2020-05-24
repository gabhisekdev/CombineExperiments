//
//  PlaceTableCell.swift
//  Nearby
//
//  Created by Abhisek on 5/23/18.
//  Copyright © 2018 Abhisek. All rights reserved.
//

import UIKit
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

class PlaceTableCell: ReusableTableViewCell {

    @IBOutlet weak var placeView: PlaceView! {
        didSet {
            let borderColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 0.6)
            placeView.layer.cornerRadius = 4
            placeView.layer.borderWidth = 1
            placeView.layer.borderColor = borderColor.cgColor
        }
    }
    
    var viewModel: PlaceTableCellVM!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func prepareCell(viewModel: PlaceTableCellVM) {
        self.viewModel = viewModel
        placeView.preparePlaceView(viewModel: viewModel.placeViewVM)
    }
    
}
