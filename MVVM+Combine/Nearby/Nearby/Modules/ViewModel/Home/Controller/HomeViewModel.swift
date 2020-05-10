//
//  HomeViewModel.swift
//  Nearby
//
//  Created by Abhisek on 13/05/18.
//  Copyright © 2018 Abhisek. All rights reserved.
//

import Foundation
import Combine

/// Enum to distinguish different home cell types
enum HomeTableCellType {
    case pagingCell(model: PaginationCellVM)
    case categoriesCell(model: TableCollectionCellVMRepresentable)
    case placesCell(model: TableCollectionCellVMRepresentable)
}

class HomeViewModel {
    private var subscriptions = Set<AnyCancellable>()
    
    /// Data source for the home page table view.
    private var tableDataSource: [HomeTableCellType] = [HomeTableCellType]()
    
    // MARK: Input
    private var viewLoaded: AnyPublisher<Void, Never> = PassthroughSubject<Void, Never>().eraseToAnyPublisher()
    private var refreshButtonTapped: AnyPublisher<Void, Never> = PassthroughSubject<Void, Never>().eraseToAnyPublisher()
    
    // MARK: Output
    var numberOfRows: Int {
        tableDataSource.count
    }
    
    var placeChoosed: AnyPublisher<NearbyPlace, Never> {
        placeChoosedSubject.eraseToAnyPublisher()
    }
    
    var categoryChoosed: AnyPublisher<PlaceType, Never> {
        categoryChoosedSubject.eraseToAnyPublisher()
    }
    
    var reloadPlaceList: AnyPublisher<Result<Void, NearbyAPIError>, Never> {
        reloadPlaceListSubject.eraseToAnyPublisher()
    }
    
    private let placeChoosedSubject = PassthroughSubject<NearbyPlace, Never>()
    private let categoryChoosedSubject = PassthroughSubject<PlaceType, Never>()
    private let reloadPlaceListSubject = PassthroughSubject<Result<Void, NearbyAPIError>, Never>()
    
    init() { }
    
    func attachViewEventListener(viewLoaded: AnyPublisher<Void, Never>, refreshButtonTapped: AnyPublisher<Void, Never>) {
        self.viewLoaded = viewLoaded
        self.refreshButtonTapped = refreshButtonTapped
        
        self.viewLoaded
            .sink { [weak self] in
                self?.fetchAppData()
        }
        .store(in: &subscriptions)
        
        self.refreshButtonTapped
            .sink { [weak self] in
                self?.tableDataSource.removeAll()
                self?.fetchAppData()
        }
        .store(in: &subscriptions)
    }
    
    private func fetchAppData() {
        AppData.sharedData.resetData()
        let placeWebservice = PlaceWebService()
        placeWebservice
            .fetchAllPlaceList()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] places in
                    AppData.sharedData.allPlaces.append(contentsOf: places)
                    self?.prepareTableDataSource()
                    self?.reloadPlaceListSubject.send(.success(()))
            })
            .store(in: &subscriptions)
    }
    
    /// Prepare the tableDataSource
    private func prepareTableDataSource() {
        tableDataSource.removeAll()
        tableDataSource.append(cellTypeForPagingCell())
        tableDataSource.append(cellTypeForCategoriesCell())
        tableDataSource.append(contentsOf: cellTypeForPlaces())
    }
    
    /// Provides a pagination cell type for each place type.
    private func cellTypeForPagingCell()->HomeTableCellType {
        var places = [NearbyPlace]()
        for placeType in PlaceType.allPlaceType() {
            places.append(contentsOf: Helper.getTopPlace(paceType: placeType, topPlacesCount: 1))
        }
        let placeSelected: (NearbyPlace)->() = { [weak self] place in
            self?.placeChoosedSubject.send(place)
        }
        return HomeTableCellType.pagingCell(model: PaginationCellVM(data: places, placeSelected: placeSelected))
    }
    
    /// Provides a placesCell type.
    private func cellTypeForCategoriesCell()->HomeTableCellType {
        let categorieVM = CategoriesTableCollectionCellVM()
        categorieVM.cellSelected = { [weak self] indexPath in
            self?.categoryChoosedSubject.send(PlaceType.allPlaceType()[indexPath.row])
        }
        return HomeTableCellType.categoriesCell(model: categorieVM)
    }
    
    /// Provides a placesCell type.
    private func cellTypeForPlaces()->[HomeTableCellType] {
        var cellTypes = [HomeTableCellType]()
        let allPlaceTypes = PlaceType.allPlaceType()
        for type in allPlaceTypes {
            let topPlaces = Helper.getTopPlace(paceType: type, topPlacesCount: 3)
            let placeCellVM = PlacesTableCollectionCellVM(dataModel: PlacesTableCollectionCellModel(places: topPlaces, title: type.homeCellTitleText))
            placeCellVM.cellSelected = { [weak self] indexPath in
                self?.placeChoosedSubject.send(topPlaces[indexPath.item])
            }
            if topPlaces.count > 0 {
                cellTypes.append(HomeTableCellType.placesCell(model: placeCellVM))
            }
        }
        return cellTypes
    }
    
    /// Provides the view with appropriate cell type corresponding to an index.
    func cellType(forIndex indexPath: IndexPath)->HomeTableCellType {
        tableDataSource[indexPath.row]
    }
    
}
