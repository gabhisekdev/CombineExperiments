//
//  PlaceTableCell.swift
//  Nearby
//
//  Created by Abhisek on 5/23/18.
//  Copyright © 2018 Abhisek. All rights reserved.
//

import UIKit
import Combine

class PlaceTableCell: ReusableTableViewCell {

    @IBOutlet weak var placeView: PlaceView!
    
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
