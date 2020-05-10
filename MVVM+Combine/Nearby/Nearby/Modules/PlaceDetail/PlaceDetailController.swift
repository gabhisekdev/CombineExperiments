//
//  PlaceDetailController.swift
//  Nearby
//
//  Created by Kuliza-241 on 5/25/18.
//  Copyright © 2018 Abhisek. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class PlaceDetailController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var openStatusLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    private var viewModel: PlaceDetailVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func prepareView(viewModel: PlaceDetailVM) {
        self.viewModel = viewModel
    }
    
    private func setUpUI() {
        titleLabel.text = viewModel.title
        openStatusLabel.text = viewModel.openStatus
        distanceLabel.text = viewModel.distance
        
        guard let lat = viewModel.location?.coordinate.latitude, let long = viewModel.location?.coordinate.longitude else { return }
        let center = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation();
        annotation.coordinate = center;
        mapView.addAnnotation(annotation);
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

}
