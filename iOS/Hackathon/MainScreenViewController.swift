//
//  MainScreenViewController.swift
//  Hackathon
//
//  Created by Nathanael Hardy on 9/16/17.
//  Copyright © 2017 Hackathon. All rights reserved.
//

import UIKit

class MainScreenViewController: UIViewController {

    @IBOutlet weak var insideView: UIView!
    @IBOutlet weak var snapImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logoView = UIImageView(image: #imageLiteral(resourceName: "pr_logo"))
        logoView.contentMode = .scaleAspectFit
        navigationItem.titleView = logoView
        
        insideView.layer.borderColor = UIColor.lightGray.cgColor
        
        snapImageView.image = snapImageView.image!.withRenderingMode(.alwaysTemplate)
        snapImageView.tintColor = UIColor.lightGray
        // Do any additional setup after loading the view.
        
        snapImageView.isUserInteractionEnabled = true
        snapImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped)))
    }

    @objc private func tapped() {
        let vc = CameraViewController()
        self.present(vc, animated: true, completion: nil)
    }

}
