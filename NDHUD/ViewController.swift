//
//  ViewController.swift
//  NDHUD
//
//  Created by Den on 10/3/17.
//  Copyright © 2017 Den. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let shapeLayer = CAShapeLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NDHUD.color = UIColor.cyan
    }
    
    @IBAction func showHUD() {
        NDHUD.show()
        let now = DispatchTime.now()
        DispatchQueue.main.asyncAfter(deadline: now + 3.0) {
            NDHUD.hide()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

