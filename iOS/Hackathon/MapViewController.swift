//
//  MapViewController.swift
//  Hackathon
//
//  Created by Ian McDowell on 9/16/17.
//  Copyright © 2017 Hackathon. All rights reserved.
//

import UIKit
import Mapbox

class MapViewController: UIViewController, CLLocationManagerDelegate {

    var mapView: MQMapView
    let locationManager = CLLocationManager()
    var myLocation = CLLocationCoordinate2D()
    var location: CLLocation
    
    init(location: CLLocation) {
        self.location = location
        mapView = MQMapView(frame: .zero)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func loadView() {
        self.view = mapView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        mapView.mapType = .normal
        mapView.userTrackingMode = .follow
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        addLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let managerLoc = manager.location {
            self.myLocation = CLLocationCoordinate2D(latitude: managerLoc.coordinate.latitude, longitude: managerLoc.coordinate.longitude)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    @objc
    func addLocation() {
        
        removeAllLocations()
        
        let parkedCar = MGLPointAnnotation()
        parkedCar.coordinate = location.coordinate
        
        mapView.addAnnotation(parkedCar)
        mapView.setCenter(parkedCar.coordinate, zoomLevel: 15, animated: true)
    }
    
    func removeAllLocations() {
        if let annotations = mapView.annotations {
            for pin in annotations {
                mapView.removeAnnotation(pin)
            }
        }
    }

}
