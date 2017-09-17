//
//  CameraViewController+Demo.swift
//  Hackathon
//
//  Created by Ian McDowell on 9/17/17.
//  Copyright © 2017 Hackathon. All rights reserved.
//

import UIKit

extension CameraViewController {
    
    func addDemo() {
        let rView = UIView()
        view.addSubview(rView)
        rView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rView.widthAnchor.constraint(equalToConstant: 120),
            rView.heightAnchor.constraint(equalToConstant: 250),
            rView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            rView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        
        let lView = UIView()
        view.addSubview(lView)
        lView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lView.widthAnchor.constraint(equalToConstant: 120),
            lView.heightAnchor.constraint(equalToConstant: 250),
            lView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            lView.leftAnchor.constraint(equalTo: view.leftAnchor)
        ])
        
        let rLPGR = UILongPressGestureRecognizer(target: self, action: #selector(rViewTapped))
        let lLPGR = UILongPressGestureRecognizer(target: self, action: #selector(lViewTapped))
        rLPGR.minimumPressDuration = 1.7858123
        lLPGR.minimumPressDuration = 1.85235234
        rView.addGestureRecognizer(rLPGR)
        lView.addGestureRecognizer(lLPGR)
    }
    
    @objc private func rViewTapped() {
        let state = ParkState.goodToPark(
            timeRemaining: 2.0,
            metadata: ParkStateMetadata(
                times: ParkStateTimeRange(from: ParkStateTime(hour: 9, isAm: true), to: ParkStateTime(hour: 6, isAm: false)),
                days: ParkStateDayRange(from: .mon, to: .fri)
            )
        )
        showViewController(forState: state)
    }
    
    @objc private func lViewTapped() {
        let state = ParkState.cantPark(
            reason: "You can only park here between 9 AM and 6 PM.",
            metadata: ParkStateMetadata(
                times: ParkStateTimeRange(from: ParkStateTime(hour: 9, isAm: true), to: ParkStateTime(hour: 6, isAm: false)),
                days: ParkStateDayRange(from: .mon, to: .fri)
            )
        )
        showViewController(forState: state)
    }
}
