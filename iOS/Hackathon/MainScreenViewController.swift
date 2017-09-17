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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
