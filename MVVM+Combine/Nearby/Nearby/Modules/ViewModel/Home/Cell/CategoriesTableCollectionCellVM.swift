//
//  CategoriesTableCollectionCellVM.swift
//  Nearby
//
//  Created by Abhisek on 21/05/18.
//  Copyright © 2018 Abhisek. All rights reserved.
//

import Foundation

class CategoriesTableCollectionCellVM: TableCollectionCellRepresentable {
    
    // Output
    var title: String = ""
    var numberOfItems: Int = 0
    
    // Events
    var cellSelected: (IndexPath)->() = { _ in }
    
    private var dataSource: [ImageAndLabelCollectionCellVM] = [ImageAndLabelCollectionCellVM]()
    
    init() {
        prepareDataSource()
        configureOutput()
    }
    
    private func prepareDataSource() {
        for type in PlaceType.allCases {
            dataSource.append(ImageAndLabelCollectionCellVM(dataModel: ImageAndLabelCollectionCellModel(name: type.displayText, imageUrl: nil, iconAssetName: type.iconName)))
        }
    }
    
    private func configureOutput() {
        title = "Want to be more specific"
        numberOfItems = dataSource.count
    }
    
    func viewModelForCell(indexPath: IndexPath) -> ImageAndLabelCollectionCellVM {
       return dataSource[indexPath.item]
    }
    
    func cellSelected(indexPath: IndexPath) {
        cellSelected(indexPath)
    }
    
}
