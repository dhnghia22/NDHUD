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
        NDHUD.color = UIColor.red
        NDHUD.lineWidth = 2.0
    }
    
    @IBAction func showHUDNative() {
        NDHUD.show(styleHUD: .Native)
        let now = DispatchTime.now()
        DispatchQueue.main.asyncAfter(deadline: now + 5.0) {
            NDHUD.hide()
        }
    }
    
    @IBAction func showHUDFLat() {
        NDHUD.show(styleHUD: .Flat)
        let now = DispatchTime.now()
        DispatchQueue.main.asyncAfter(deadline: now + 5.0) {
            NDHUD.hide()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

