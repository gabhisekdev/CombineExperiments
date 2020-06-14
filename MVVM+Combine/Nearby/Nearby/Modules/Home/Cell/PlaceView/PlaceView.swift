//
//  PlaceView.swift
//  Nearby
//
//  Created by Abhisek on 14/05/18.
//  Copyright © 2018 Abhisek. All rights reserved.
//

import UIKit
import Kingfisher
import Combine

@IBDesignable
class PlaceView: UIView {
    private var subscriptions = Set<AnyCancellable>()
    
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
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
            view.topAnchor.constraint(equalTo: topAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func preparePlaceView(viewModel: PlaceViewVM) {
        self.viewModel = viewModel
        setUpUI()
    }
    
    private func setUpUI() {
        subscriptions = [
            viewModel.$name.assign(to: \.text!, on: placeNameLabel),
            viewModel.$distance.assign(to: \.text!, on: distanceLabel)
        ]
        
        viewModel.$placeImageUrl.compactMap { URL(string: $0) }
        .sink { [weak self] imageURL in
            self?.placeImageView.kf.setImage(with: imageURL, placeholder: UIImage(named : "placeIcon"), options: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, url) in
                })
        }
        .store(in: &subscriptions)
    }
    
    @IBAction func placeViewTapped(_ sender: Any) {
        viewModel.placesViewPressed()
    }
    
}
