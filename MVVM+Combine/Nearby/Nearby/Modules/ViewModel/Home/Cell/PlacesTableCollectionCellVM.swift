//
//  PlacesTableCollectionCellVM.swift
//  Nearby
//
//  Created by Abhisek on 14/05/18.
//  Copyright © 2018 Abhisek. All rights reserved.
//

import Foundation
import Combine

protocol TableCollectionCellRepresentable {
    // Output
    var title: String { get }
    var numberOfItems: Int { get }
    func viewModelForCell(indexPath: IndexPath) -> ImageAndLabelCollectionCellVM
    var cellSelected: AnyPublisher<IndexPath, Never> { get }
    
    //Input
    func cellSelected(indexPath: IndexPath)
 }

struct PlacesTableCollectionCellModel {
    let places: [NearbyPlace]
    let title: String
}

class PlacesTableCollectionCellVM: TableCollectionCellRepresentable {
    var numberOfItems: Int = 0
    var title: String = ""
    private var dataModel: PlacesTableCollectionCellModel!
    private var dataSource: [ImageAndLabelCollectionCellVM] = [ImageAndLabelCollectionCellVM]()
    
    var cellSelected: AnyPublisher<IndexPath, Never> {
        cellSelctedSubject.eraseToAnyPublisher()
    }
    private let cellSelctedSubject = PassthroughSubject<IndexPath, Never>()
    
    init(dataModel: PlacesTableCollectionCellModel) {
        self.dataModel = dataModel
        prepareCollectionDataSource()
        configureOutput()
    }
    
    private func configureOutput() {
        title = dataModel.title
        numberOfItems = dataSource.count
    }
    
    private func prepareCollectionDataSource() {
        if dataModel.places.count == 0 { return }
        let totalCount =  dataModel.places.count >= 3 ? 3 : dataModel.places.count
        for i in 0..<totalCount {
            let place = dataModel.places[i]
            let imageAndLabelDm = ImageAndLabelCollectionCellModel(name: place.name, imageUrl: place.imageURL, iconAssetName: nil)
            dataSource.append(ImageAndLabelCollectionCellVM(dataModel: imageAndLabelDm))
        }
    }
    
    func viewModelForCell(indexPath: IndexPath) -> ImageAndLabelCollectionCellVM {
        return dataSource[indexPath.row]
    }
    
    func cellSelected(indexPath: IndexPath) {
        cellSelctedSubject.send(indexPath)
    }
    
}
