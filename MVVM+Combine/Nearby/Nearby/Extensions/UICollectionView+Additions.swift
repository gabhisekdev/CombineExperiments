//
//  UICollectionView+Additions.swift
//  Nearby
//
//  Created by Abhisek on 5/24/18.
//  Copyright © 2018 Abhisek. All rights reserved.
//

import Foundation
import UIKit

open class ReusableCollectionViewCell: UICollectionViewCell {
    
    /// Reuse Identifier String
    public class var reuseIdentifier: String {
        return "\(self.self)"
    }
    
    /// Registers the Nib with the provided table
    public static func registerWithCollectionView(_ collectionView: UICollectionView) {
        let bundle = Bundle(for: self)
        let nib = UINib(nibName: self.reuseIdentifier , bundle: bundle)
        collectionView.register(nib, forCellWithReuseIdentifier: self.reuseIdentifier)
    }
    
}
