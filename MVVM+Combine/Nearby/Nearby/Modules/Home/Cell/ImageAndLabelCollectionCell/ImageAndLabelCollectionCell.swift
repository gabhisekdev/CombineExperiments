//
//  ImageAndLabelCollectionCell.swift
//  Nearby
//
//  Created by Abhisek on 20/05/18.
//  Copyright © 2018 Abhisek. All rights reserved.
//

import UIKit

class ImageAndLabelCollectionCell: ReusableCollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    
    private var viewModel: ImageAndLabelCollectionCellVM!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel = nil
    }
    
    func prepareCell(viewModel: ImageAndLabelCollectionCellVM) {
        self.viewModel = viewModel
        setUpUI()
    }
    
    private func setUpUI() {
        guard let viewModel = self.viewModel else { return }
        textLabel.text = viewModel.text
        if let imageName = viewModel.assetName {
            imageView.image = UIImage(named: imageName)
        } else if let imageURL = viewModel.imageURL {
            imageView.kf.setImage(with: URL(string: imageURL), placeholder: UIImage(named : "placeIcon"), options: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, url) in
            })
        }
        
    }
    
}
