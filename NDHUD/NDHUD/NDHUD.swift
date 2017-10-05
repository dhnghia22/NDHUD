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
    var hudView = HUDView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
    let backgroundView: UIView = {
        let view = UIView(frame: CGRect.zero)
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3)
        return view
    }()
}

open class NDHUD {
    static let shared: NDHUD = NDHUD()
    
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
    
    open static var cornerRadius: CGFloat? {
        didSet {
            HUD.shared.hudView.layer.cornerRadius = cornerRadius!
        }
    }
    
    open static var backgroundHUDColor: UIColor? {
        didSet {
            HUD.shared.hudView.contentView.backgroundColor = backgroundHUDColor!
        }
    }
    
    open static var backgroundColor: UIColor? {
        didSet {
            HUD.shared.backgroundView.backgroundColor = backgroundColor!
        }
    }
    
    open static var styleHUD: HUDStyle? {
        didSet {
            HUD.shared.hudView.HUDStyle = styleHUD!
            HUD.shared.hudView.updatePath()
        }
    }
    
    open class func show(onViewController vc: UIViewController? = nil, styleHUD style: HUDStyle? = nil) {
        if let style = style {
            self.styleHUD = style
        }
        if let vc = vc {
            HUD.shared.hudView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            HUD.shared.hudView.alpha = 0.0
            if let navi = vc.navigationController {
                self.addHUD(toview: navi.view)
            } else {
                self.addHUD(toview: vc.view)
            }
            
        } else {
            var window: UIWindow!
            if let _ = UIApplication.shared.keyWindow {
                window =  UIApplication.shared.keyWindow!
            } else {
                window = UIApplication.shared.windows[0]
            }
            self.addHUD(toview: window)
        }
    }
    
    private class func addHUD(toview view: UIView) {
        if !view.subviews.contains(HUD.shared.backgroundView) {
            HUD.shared.backgroundView.frame = view.frame
            HUD.shared.hudView.center = HUD.shared.backgroundView.center
            // Animation addsubview
            HUD.shared.backgroundView.alpha = 0.0
            HUD.shared.hudView.alpha = 0.0
            
            view.addSubview(HUD.shared.backgroundView)
            HUD.shared.backgroundView.addSubview(HUD.shared.hudView)
            
            UIView.animate(withDuration: 0.2) {
                HUD.shared.hudView.alpha = 1.0
                HUD.shared.backgroundView.alpha = 1.0
                HUD.shared.hudView.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
            HUD.shared.hudView.startAnimation()
        }
    }
    
    open class func hide() {
//        var window: UIWindow!
//        if let _ = UIApplication.shared.keyWindow {
//            window =  UIApplication.shared.keyWindow!
//        } else {
//            window = UIApplication.shared.windows[0]
//        }
//        let transition = CATransition()
//        transition.duration = 0.2
//        transition.type = kCATransitionFade
//        window.layer.add(transition, forKey: nil)
//        window.addSubview(HUD.shared.hudView)
        UIView.animate(withDuration: 0.2, animations: {
            HUD.shared.hudView.alpha = 0.0
            HUD.shared.backgroundView.alpha = 0.0
            HUD.shared.hudView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { (_) in
            HUD.shared.hudView.stopAnimation()
            HUD.shared.hudView.removeFromSuperview()
            HUD.shared.backgroundView.removeFromSuperview()
            HUD.shared.hudView.stopAnimation()
        }
    }
}
