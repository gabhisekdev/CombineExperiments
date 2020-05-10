//
//  PlaceView.swift
//  Nearby
//
//  Created by Abhisek on 14/05/18.
//  Copyright © 2018 Abhisek. All rights reserved.
//

import UIKit
import Kingfisher

@IBDesignable
class PlaceView: UIView {

    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    private var viewModel: PlaceViewVM!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadXib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadXib()
    }
    
    func loadXib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "PlaceView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
    
    func preparePlaceView(viewModel: PlaceViewVM) {
        self.viewModel = viewModel
        setUpUI()
    }
    
    private func setUpUI() {
        placeNameLabel.text = viewModel.name
        distanceLabel.text = viewModel.distance
        placeImageView.kf.indicatorType = IndicatorType.activity
        placeImageView.kf.setImage(with: URL(string: viewModel.placeImageUrl), placeholder: UIImage(named : "PlacesPlaceholder"), options: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, url) in
        })
    }
    
    @IBAction func placeViewTapped(_ sender: Any) {
        viewModel.placesViewPressed()
    }
    
}
