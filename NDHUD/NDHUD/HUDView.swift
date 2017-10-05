//
//  HUDView.swift
//  NDHUD
//
//  Created by Den on 10/3/17.
//  Copyright © 2017 Den. All rights reserved.
//

import UIKit

public enum HUDStyle {
    case Native
    case Flat
}



class HUDView: UIView {
    @IBOutlet var contentView: UIView!
    var HUDColor: UIColor = UIColor.black
    var HUDLineWidth: CGFloat = 2.0
    var HUDPath = UIBezierPath()
    var shapeLayer = CAShapeLayer()
    
    var HUDStyle: HUDStyle = .Flat
    
   // var indefiniteAnimatedLayer: CAShapeLayer()
    
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
    
    
    let groupLoadingNativeAnimation: CAAnimationGroup = {
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
    
    
    let flatAnimation: CABasicAnimation = {
        let animationDuration = 1.0
        let linearCurve = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.fromValue = 0
        animation.toValue = Double.pi * 2
        animation.duration = animationDuration
        animation.timingFunction = linearCurve
        animation.isRemovedOnCompletion = false
        animation.repeatCount = .infinity
        animation.fillMode = kCAFillModeForwards
        animation.autoreverses = false
        return animation
    }()
    
    let groupLoadingFlatAnimation: CAAnimationGroup = {

        let animationStrokeStart = CABasicAnimation(keyPath: "strokeStart")
        animationStrokeStart.fromValue = 0.015
        animationStrokeStart.byValue = 0.515
        
        let animationStrokeEnd = CABasicAnimation(keyPath: "strokeEnd")
        animationStrokeEnd.fromValue = 0.485
        animationStrokeEnd.byValue = 0.985
        
        
     
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = 1.0
        animationGroup.repeatCount = .infinity
        animationGroup.isRemovedOnCompletion = false
        animationGroup.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animationGroup.animations = [animationStrokeStart, animationStrokeEnd]
        return animationGroup
    }()
    
    
    private let maskLayer: CALayer = {
        let maskLayer = CALayer()
        let bundle = Bundle(for: HUDView.self)
        let url = bundle.url(forResource: "NDHUD", withExtension: "bundle")
        let imageBundle = Bundle(url: url!)
        
        let path = imageBundle!.path(forResource: "angle-mask", ofType: "png")
        maskLayer.contents = UIImage(contentsOfFile: path!)!.cgImage!
        return maskLayer
    }()
    
    func setupHUD() {
        //self.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
//        shapeLayer.removeFromSuperlayer()

        
        let path = self.getHUDPath(style: self.HUDStyle)
        
        shapeLayer.contentsScale = UIScreen.main.scale
        shapeLayer.frame = self.frame
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = HUDColor.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = HUDLineWidth
        shapeLayer.lineCap = kCALineCapRound
        //_indefiniteAnimatedLayer.frame = CGRectMake(0.0f, 0.0f, arcCenter.x*2, arcCenter.y*2);
        self.updateMaskLayer()
        self.layer.addSublayer(shapeLayer)
        
        
    }
    
    func updatePath() {
        let path = self.getHUDPath(style: self.HUDStyle)
        shapeLayer.path = path.cgPath
        self.shapeLayer.setNeedsDisplay()
        self.updateMaskLayer()
    }
    
    private func updateMaskLayer() {
        switch self.HUDStyle {
        case .Native:
            shapeLayer.mask = nil
            break
        case .Flat:
            maskLayer.frame = shapeLayer.bounds
            shapeLayer.mask = maskLayer
            break
        }
        
    }
    
    
    func startAnimation() {
        switch self.HUDStyle {
        case .Native:
            shapeLayer.add(groupLoadingNativeAnimation, forKey: "groupLoadingNativeAnimation")
            break
        case .Flat:
            shapeLayer.mask?.add(flatAnimation, forKey: "flatAnimation")
            //shapeLayer.add(groupLoadingFlatAnimation, forKey: "groupLoadingFlatAnimation")
            break
        
        }
    }
    
    func stopAnimation() {
        shapeLayer.removeAllAnimations()
    }
    
    func getHUDPath(style hudStyle: HUDStyle) -> UIBezierPath {
        switch hudStyle {
        case .Flat:
            return flatHUDPath
        case .Native:
            return nativeHUDPath
        }
    }
    
    
    private lazy var flatHUDPath: UIBezierPath = {
        let smoothedPath  = UIBezierPath(arcCenter: self.center, radius: 24, startAngle: CGFloat(Double.pi * 3 / 2), endAngle: CGFloat(Double.pi * 3 / 2 +  Double.pi * 2), clockwise: true)
        return smoothedPath
    }()
    
    
    
    
    private lazy var nativeHUDPath: UIBezierPath = {
        let path = UIBezierPath()
        
        let point = CGPoint(x: self.center.x, y: self.center.y )
        path.addArc( withCenter: point,
                        radius: 24.0,
                        startAngle: 0,
                        endAngle: CGFloat( 2 * Double.pi ),
                        clockwise: true )
        
        return path
    }()
    
    
    
    
    
    
    

}
