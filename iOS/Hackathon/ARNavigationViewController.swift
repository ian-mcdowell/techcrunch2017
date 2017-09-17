//
//  ARNavigationViewController.swift
//  Hackathon
//
//  Created by Ian McDowell on 9/17/17.
//  Copyright © 2017 Hackathon. All rights reserved.
//

import UIKit
import SceneKit
import CoreLocation

class ARNavigationViewController: UIViewController, SceneLocationViewDelegate {
    
    let location: CLLocation
    let sceneLocationView: SceneLocationView
    let infoLabel: UILabel
    var updateInfoLabelTimer: Timer?
    
    let mapVC: MapViewController
    let doneButton = UIButton(type: .system)
    
    var pinNode: LocationAnnotationNode {
        didSet {
            sceneLocationView.removeLocationNode(locationNode: oldValue)
            sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: pinNode)
        }
    }
    
    init(location: CLLocation) {
        self.location = location
        sceneLocationView = SceneLocationView()
        infoLabel = UILabel()
        
        let image = UIImage(named: "arpin")!
        pinNode = LocationAnnotationNode(location: location, image: image)
        
        mapVC = MapViewController(location: location)
        
        super.init(nibName: nil, bundle: nil)
        
        sceneLocationView.locationDelegate = self
        sceneLocationView.showFeaturePoints = true
        
        addChildViewController(mapVC)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(sceneLocationView)
        
        mapVC.view.alpha = 0.7
        mapVC.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapVC.view)
        NSLayoutConstraint.activate([
            mapVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapVC.view.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.33)
        ])
        
        infoLabel.font = UIFont.systemFont(ofSize: 10)
        infoLabel.textAlignment = .left
        infoLabel.textColor = UIColor.white
        infoLabel.numberOfLines = 0
        sceneLocationView.addSubview(infoLabel)
        
        updateInfoLabelTimer = Timer.scheduledTimer(
            timeInterval: 0.1,
            target: self,
            selector: #selector(updateInfoLabel),
            userInfo: nil,
            repeats: true)
        
        doneButton.setTitle("Done", for: .normal)
        doneButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        view.addSubview(doneButton)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            doneButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            doneButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15)
        ])
    }
    
    @objc private func close() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.hasActiveSession = false
        delegate.updateRootViewController()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        sceneLocationView.frame = view.bounds
        infoLabel.frame = CGRect(x: 6, y: 0, width: self.view.frame.size.width - 12, height: 14 * 4)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        sceneLocationView.run()
        
        pinNode.continuallyAdjustNodePositionWhenWithinRange = false
        sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: pinNode)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneLocationView.pause()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let image = UIImage(named: "arpin")!
        let location = sceneLocationView.currentLocation()!
        pinNode = LocationAnnotationNode(location: location, image: image)
        pinNode.continuallyAdjustNodePositionWhenWithinRange = false
    }
    
    
    //MARK: SceneLocationViewDelegate
    
    func sceneLocationViewDidAddSceneLocationEstimate(sceneLocationView: SceneLocationView, position: SCNVector3, location: CLLocation) {
        print("add scene location estimate, position: \(position), location: \(location.coordinate), accuracy: \(location.horizontalAccuracy), date: \(location.timestamp)")
    }
    
    func sceneLocationViewDidRemoveSceneLocationEstimate(sceneLocationView: SceneLocationView, position: SCNVector3, location: CLLocation) {
        print("remove scene location estimate, position: \(position), location: \(location.coordinate), accuracy: \(location.horizontalAccuracy), date: \(location.timestamp)")
    }
    
    func sceneLocationViewDidConfirmLocationOfNode(sceneLocationView: SceneLocationView, node: LocationNode) {
    }
    
    func sceneLocationViewDidSetupSceneNode(sceneLocationView: SceneLocationView, sceneNode: SCNNode) {
        
    }
    
    func sceneLocationViewDidUpdateLocationAndScaleOfLocationNode(sceneLocationView: SceneLocationView, locationNode: LocationNode) {
        
    }
    
    
    @objc func updateInfoLabel() {
        if let position = sceneLocationView.currentScenePosition() {
            infoLabel.text = "x: \(String(format: "%.2f", position.x)), y: \(String(format: "%.2f", position.y)), z: \(String(format: "%.2f", position.z))\n"
        }
        
        if let eulerAngles = sceneLocationView.currentEulerAngles() {
            infoLabel.text!.append("Euler x: \(String(format: "%.2f", eulerAngles.x)), y: \(String(format: "%.2f", eulerAngles.y)), z: \(String(format: "%.2f", eulerAngles.z))\n")
        }
        
        if let heading = sceneLocationView.locationManager.heading,
            let accuracy = sceneLocationView.locationManager.headingAccuracy {
            infoLabel.text!.append("Heading: \(heading)º, accuracy: \(Int(round(accuracy)))º\n")
        }
        
        let date = Date()
        let comp = Calendar.current.dateComponents([.hour, .minute, .second, .nanosecond], from: date)
        
        if let hour = comp.hour, let minute = comp.minute, let second = comp.second, let nanosecond = comp.nanosecond {
            infoLabel.text!.append("\(String(format: "%02d", hour)):\(String(format: "%02d", minute)):\(String(format: "%02d", second)):\(String(format: "%03d", nanosecond / 1000000))")
        }
    }
}
