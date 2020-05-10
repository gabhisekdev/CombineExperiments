//
//  PlaceTableCell.swift
//  Nearby
//
//  Created by Abhisek on 5/23/18.
//  Copyright © 2018 Abhisek. All rights reserved.
//

import UIKit

class PlaceTableCellVM {
    
    private var place: NearbyPlace!
    
    var placeViewVM: PlaceViewVM!
    var placeSelected: (NearbyPlace)->() = { _ in }
    
    init(place: NearbyPlace) {
        self.place = place
        preparePlaceViewVM()
    }
    
    private func preparePlaceViewVM() {
        placeViewVM = PlaceViewVM(place: place)
        placeViewVM.placesViewSelected = { [weak self] in
            guard let _self = self else { return }
            _self.placeSelected(_self.place)
        }
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
