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
    case categoriesCell(model: TableCollectionCellRepresentable)
    case placesCell(model: TableCollectionCellRepresentable)
}

class HomeViewModel {
    private var subscriptions = Set<AnyCancellable>()
    
    /// Data source for the home page table view.
    private var tableDataSource: [HomeTableCellType] = [HomeTableCellType]()
    private var allPlaces = [NearbyPlace]()
    
    // MARK: Input
    private var loadData: AnyPublisher<Void, Never> = PassthroughSubject<Void, Never>().eraseToAnyPublisher()
    
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
    
    func attachViewEventListener(loadData: AnyPublisher<Void, Never>) {
        self.loadData = loadData
        self.loadData
            .setFailureType(to: NearbyAPIError.self)
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.allPlaces.removeAll()
            })
            .flatMap { _ -> AnyPublisher<[NearbyPlace], NearbyAPIError> in
                let placeWebservice = PlaceWebService()
                return placeWebservice
                    .fetchAllPlaceList()
            }
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.tableDataSource.removeAll()
            })
            .sink(receiveCompletion: { _ in },
              receiveValue: { [weak self] places in
                self?.allPlaces.append(contentsOf: places)
                self?.prepareTableDataSource()
                self?.reloadPlaceListSubject.send(.success(()))
            })
            .store(in: &subscriptions)
    }
    
    /// Prepare the tableDataSource
    private func prepareTableDataSource() {
        tableDataSource.append(cellTypeForPagingCell())
        tableDataSource.append(cellTypeForCategoriesCell())
        tableDataSource.append(contentsOf: cellTypeForPlaces())
    }
    
    /// Provides a pagination cell type for each place type.
    private func cellTypeForPagingCell()->HomeTableCellType {
        var places = [NearbyPlace]()
        for placeType in PlaceType.allCases {
            places.append(contentsOf: getTopPlace(paceType: placeType, topPlacesCount: 1))
        }
        let placeSelected: (NearbyPlace)->() = { [weak self] place in
            self?.placeChoosedSubject.send(place)
        }
        
        let paginationCellVM = PaginationCellVM(data: places)
        paginationCellVM.placeSelected
            .sink(receiveValue: placeSelected)
            .store(in: &subscriptions)
        
        return HomeTableCellType.pagingCell(model: paginationCellVM)
    }
    
    /// Provides a placesCell type.
    private func cellTypeForCategoriesCell()->HomeTableCellType {
        let categorieVM = CategoriesTableCollectionCellVM()
        
        categorieVM.cellSelected.sink { [weak self] indexPath in
            self?.categoryChoosedSubject.send(PlaceType.allCases[indexPath.row])
        }
        .store(in: &subscriptions)
        
        return HomeTableCellType.categoriesCell(model: categorieVM)
    }
    
    /// Provides a placesCell type.
    private func cellTypeForPlaces()->[HomeTableCellType] {
        var cellTypes = [HomeTableCellType]()
        let allPlaceTypes = PlaceType.allCases
        for type in allPlaceTypes {
            let topPlaces = getTopPlace(paceType: type, topPlacesCount: 3)
            let placeCellVM = PlacesTableCollectionCellVM(dataModel: PlacesTableCollectionCellModel(places: topPlaces, title: type.homeCellTitleText))
            
            placeCellVM.cellSelected.sink { [weak self] indexPath in
                self?.placeChoosedSubject.send(topPlaces[indexPath.item])
            }
            .store(in: &subscriptions)
            
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
    
    func getTopPlace(paceType: PlaceType, topPlacesCount: Int) -> [NearbyPlace] {
        let places = allPlaces.filter { $0.type == paceType }
        return Array(places.prefix(topPlacesCount))
    }
    
    func getPlaceListViewModel(placeType: PlaceType) -> PlaceListViewModel {
        let places = allPlaces.filter { $0.type == placeType }
        return PlaceListViewModel(allPlaces: places, placeType: placeType)
    }
}
