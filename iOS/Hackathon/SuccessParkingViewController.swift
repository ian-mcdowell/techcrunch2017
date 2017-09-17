//
//  SuccessParkingViewController.swift
//  Hackathon
//
//  Created by Nathanael Hardy on 9/17/17.
//  Copyright © 2017 Hackathon. All rights reserved.
//

import UIKit

class SuccessParkingViewController: UIViewController {

    @IBOutlet weak var parkingDurationLabel: UILabel!
    @IBOutlet weak var expirationTimeLabel: UILabel!
    @IBOutlet weak var crimeRateLabel: UILabel!
    @IBOutlet weak var walkingScoreLabel: UILabel!
    
    var timeRemaining: TimeInterval?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(close))
        // Do any additional setup after loading the view.
    }
    
    @objc private func close() {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    func setParkingDuration(_ duration: TimeInterval) {
        // load view
        let _ = self.view
        
        self.timeRemaining = duration
        parkingDurationLabel.text = "\(self.timeRemaining ?? 0 ) hours"
        
        let finalDate = Calendar.current.date(byAdding: .hour, value: Int(duration), to: Date(), wrappingComponents: false)!
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        expirationTimeLabel.text = formatter.string(from: finalDate)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func saveSpotPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "main", bundle: nil)
        let nav = storyboard.instantiateViewController(withIdentifier: "activeParking")
        let vc = nav.childViewControllers.first as! CurrentSessionViewController
        vc.timeRemaining = self.timeRemaining
        self.present(nav, animated: true, completion: nil)
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
