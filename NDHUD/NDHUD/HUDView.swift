//
//  HUDView.swift
//  NDHUD
//
//  Created by Den on 10/3/17.
//  Copyright © 2017 Den. All rights reserved.
//

import UIKit

class HUDView: UIView {
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var contentHudView: UIView!
    var HUDColor: UIColor = UIColor.black
    var HUDLineWidth: CGFloat = 5.0
    var HUDPath = UIBezierPath()
    let shapeLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
        
    }
    
    fileprivate func customInit() {
        Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)
        self.addSubview(contentView)
        contentView.frame = self.frame
        setupHUD()
    }
    
    
    let groupLoadingAnimation: CAAnimationGroup = {
        let animationStrokeEnd = CABasicAnimation(keyPath: "strokeEnd")
        animationStrokeEnd.fromValue = 0.0
        animationStrokeEnd.byValue = 1.0
        animationStrokeEnd.duration = 1.45
        animationStrokeEnd.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animationStrokeEnd.fillMode = kCAFillModeForwards
        animationStrokeEnd.isRemovedOnCompletion = false
        
        let animationStrokeStart = CABasicAnimation(keyPath: "strokeStart")
        animationStrokeStart.fromValue = 0.0
        animationStrokeStart.byValue = 1.0
        animationStrokeStart.duration = 1.75
        animationStrokeStart.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        animationStrokeStart.fillMode = kCAFillModeBackwards
        animationStrokeStart.isRemovedOnCompletion = false
        
        let group = CAAnimationGroup()
        group.animations = [animationStrokeEnd, animationStrokeStart]
        group.duration = 1.75
        group.repeatCount = .infinity
        return group
    }()
    
    private func setupHUD() {
        HUDPath = UIBezierPath()
        /* draw code goes here*/
        HUDPath.addArc( withCenter: self.center,
                           radius: 20.0,
                           startAngle: 0,
                           endAngle: CGFloat( 2 * Double.pi ),
                           clockwise: true )
        /* assign a path to CAShapeLayer */
        shapeLayer.path = HUDPath.cgPath
        shapeLayer.strokeColor = HUDColor.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = HUDLineWidth
        shapeLayer.lineCap = kCALineCapRound
        self.layer.addSublayer(shapeLayer)
    }
    
    func startAnimation() {
        shapeLayer.add(groupLoadingAnimation, forKey: "shuffle")
    }
    
    func stopAnimation() {
        shapeLayer.removeAnimation(forKey: "shuffle")
    }
    
    
    
    
    

}
