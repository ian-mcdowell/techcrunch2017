//
//  ViewController.swift
//  Hackathon
//
//  Created by Ian McDowell on 9/16/17.
//  Copyright © 2017 Hackathon. All rights reserved.
//

import UIKit
import Mapbox

class ViewController: UIViewController, CLLocationManagerDelegate {

    var mapView: MQMapView?
    let locationManager = CLLocationManager()
    var myLocation = CLLocationCoordinate2D()
    var setLocationButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let frame = self.view.frame
        mapView = MQMapView(frame: frame)
        if let mapView = mapView {
            mapView.mapType = .normal
            mapView.userTrackingMode = .follow
            self.view.addSubview(mapView)
        }
        
        setLocationButton.frame = CGRect(x: 0, y: self.view.frame.height - 50.0, width: self.view.frame.width, height: 50)
        setLocationButton.backgroundColor = .blue
        setLocationButton.setTitle("Set Location", for: .normal)
        setLocationButton.addTarget(self, action: #selector(addLocation), for: .touchUpInside)
        self.view.addSubview(setLocationButton)
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
    }
    
    func setupLocationManager() {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let managerLoc = manager.location {
            self.myLocation = CLLocationCoordinate2D(latitude: managerLoc.coordinate.latitude, longitude: managerLoc.coordinate.longitude)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    @objc
    func addLocation() {
        
        removeAllLocations()
        
        let parkedCar = MGLPointAnnotation()
        parkedCar.coordinate = myLocation
        parkedCar.title = "Parked Car"
        parkedCar.subtitle = "53 Minutes left"
        
        if let mapView = mapView {
            mapView.addAnnotation(parkedCar)
            mapView.setCenter(parkedCar.coordinate, zoomLevel: 15, animated: true)
        }
    }
    
    func removeAllLocations() {
        if let annotations = mapView?.annotations {
            for pin in annotations {
                mapView?.removeAnnotation(pin)
            }
        }
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
  
}
