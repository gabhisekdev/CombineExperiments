//
//  UICollectionView+Additions.swift
//  DemoMVVM
//
//  Created by Abhisek on 26/04/18.
//  Copyright © 2018 Abhisek. All rights reserved.
//

import Foundation
import UIKit

open class ReusableTableViewCell: UITableViewCell {
    
    /// Reuse Identifier String
    public class var reuseIdentifier: String {
        return "\(self.self)"
    }
    
    /// Registers the Nib with the provided table
    public static func registerWithTable(_ table: UITableView) {
        let bundle = Bundle(for: self)
        let nib = UINib(nibName: self.reuseIdentifier , bundle: bundle)
        table.register(nib, forCellReuseIdentifier: self.reuseIdentifier)
    }
    
}
