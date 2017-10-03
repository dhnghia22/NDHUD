//
//  NDHUD.swift
//  NDHUD
//
//  Created by Den on 10/4/17.
//  Copyright © 2017 Den. All rights reserved.
//

import Foundation
import UIKit

class HUD {
    static let shared = HUD()
    var hudView = HUDView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
}

open class NDHUD {
    open static let shared: NDHUD = NDHUD()
    
    
    open static var color: UIColor? {
        didSet {
            HUD.shared.hudView.shapeLayer.strokeColor = color!.cgColor
        }
    }
    
    open static var lineWidth: CGFloat? {
        didSet {
            HUD.shared.hudView.shapeLayer.lineWidth = lineWidth!
        }
    }
    
    open class func show() {
        var window: UIWindow!
        if let _ = UIApplication.shared.keyWindow {
            window =  UIApplication.shared.keyWindow!
        } else {
            window = UIApplication.shared.windows[0]
        }
        let transition = CATransition()
        transition.duration = 0.2
        transition.type = kCATransitionFade
        window.layer.add(transition, forKey: nil)
        window.addSubview(HUD.shared.hudView)
        HUD.shared.hudView.startAnimation()
    }
    
    open class func hide() {
        var window: UIWindow!
        if let _ = UIApplication.shared.keyWindow {
            window =  UIApplication.shared.keyWindow!
        } else {
            window = UIApplication.shared.windows[0]
        }
        let transition = CATransition()
        transition.duration = 0.2
        transition.type = kCATransitionFade
        window.layer.add(transition, forKey: nil)
        window.addSubview(HUD.shared.hudView)
        HUD.shared.hudView.stopAnimation()
        HUD.shared.hudView.removeFromSuperview()
    }
}
