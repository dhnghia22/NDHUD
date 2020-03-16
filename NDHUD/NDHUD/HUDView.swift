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



open class HUDView: UIView {
    @IBOutlet var contentView: UIView!
    open var HUDColor: UIColor = UIColor.black {
        didSet {
            shapeLayer.strokeColor = HUDColor.cgColor
        }
    }
    open var HUDLineWidth: CGFloat = 2.0  {
        didSet {
            shapeLayer.lineWidth = HUDLineWidth
        }
    }
    open var HUDPath = UIBezierPath()
    open var shapeLayer = CAShapeLayer()
    open var HUDStyle: HUDStyle = .Flat  {
        didSet {
            self.updatePath()
        }
    }

    
   // var indefiniteAnimatedLayer: CAShapeLayer()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
        
    }
    
    fileprivate func customInit() {
        
//        let bundle = Bundle(for: self.classForCoder)
//        contentView = bundle.loadNibNamed(String(describing: type(of: self), owner: nil, options: nil))?.first
        let bundle = Bundle(for: HUDView.self)
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        contentView = nib.instantiate(withOwner: self, options: nil)[0] as? UIView
        contentView.frame = self.frame
        self.addSubview(contentView)
        setupHUD()
    }
    
    
    let groupLoadingNativeAnimation: CAAnimationGroup = {
        let animationStrokeEnd = CABasicAnimation(keyPath: "strokeEnd")
        animationStrokeEnd.fromValue = 0.0
        animationStrokeEnd.byValue = 1.0
        animationStrokeEnd.duration = 1.45
        animationStrokeEnd.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animationStrokeEnd.fillMode = CAMediaTimingFillMode.forwards
        animationStrokeEnd.isRemovedOnCompletion = false
        
        let animationStrokeStart = CABasicAnimation(keyPath: "strokeStart")
        animationStrokeStart.fromValue = 0.0
        animationStrokeStart.byValue = 1.0
        animationStrokeStart.duration = 1.75
        animationStrokeStart.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        animationStrokeStart.fillMode = CAMediaTimingFillMode.backwards
        animationStrokeStart.isRemovedOnCompletion = false
        
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = 1.75
        animationGroup.repeatCount = .infinity
        animationGroup.isRemovedOnCompletion = false
        animationGroup.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animationGroup.animations = [animationStrokeStart, animationStrokeEnd]
        return animationGroup
    }()
    
    
    let flatAnimation: CABasicAnimation = {
        let animationDuration = 1.0
        let linearCurve = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.fromValue = 0
        animation.toValue = Double.pi * 2
        animation.duration = animationDuration
        animation.timingFunction = linearCurve
        animation.isRemovedOnCompletion = false
        animation.repeatCount = .infinity
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.autoreverses = false
        return animation
    }()
    
    
    let rotateAnimation: CABasicAnimation = {
        let animationDuration = 2.0
        let linearCurve = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.fromValue = 0
        animation.toValue = Double.pi * 2
        animation.duration = animationDuration
        animation.timingFunction = linearCurve
        animation.isRemovedOnCompletion = false
        animation.repeatCount = .infinity
        animation.fillMode = CAMediaTimingFillMode.forwards
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
        animationGroup.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
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
        let path = self.getHUDPath(style: self.HUDStyle)
        shapeLayer.contentsScale = UIScreen.main.scale
        shapeLayer.frame = self.frame
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = HUDColor.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = HUDLineWidth
        shapeLayer.lineCap = CAShapeLayerLineCap.round
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
    
    
    open func startAnimation() {
        switch self.HUDStyle {
        case .Native:
            shapeLayer.add(rotateAnimation, forKey: "flatAnimation")
            shapeLayer.add(groupLoadingNativeAnimation, forKey: "groupLoadingNativeAnimation")
            break
        case .Flat:
            shapeLayer.mask?.add(flatAnimation, forKey: "flatAnimation")
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
        let radius = self.frame.width <= self.frame.height ? self.frame.width / 2 * 2 / 3 : self.frame.height / 2 * 2 / 3
        let path  = UIBezierPath(arcCenter: self.center, radius: radius, startAngle: CGFloat(Double.pi * 3 / 2), endAngle: CGFloat(Double.pi * 3 / 2 +  Double.pi * 2), clockwise: true)
        return path
    }()
    
    
    
    
    private lazy var nativeHUDPath: UIBezierPath = {
        let path = UIBezierPath()
        let point = CGPoint(x: self.center.x, y: self.center.y )
        let radius = self.frame.width <= self.frame.height ? self.frame.width / 2 * 2 / 3 : self.frame.height / 2 * 2 / 3
        path.addArc( withCenter: point,
                        radius: radius,
                        startAngle: 0,
                        endAngle: CGFloat( 2 * Double.pi ),
                        clockwise: true )
        return path
    }()

}
