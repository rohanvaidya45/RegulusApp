//
//  Welcome.swift
//  Measure
//
//  Created by Rohan Vaidya on 6/18/23.
//  Copyright © 2023 SAP. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController{
    
    @IBOutlet weak var segueButton: UIButton!
    override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view.
        }
    @IBAction func segue(_ sender: Any) {
        performSegue(withIdentifier: "MeasureView", sender: self)
    }
}
