//
//  MicrophoneActivityIndicatorView.swift
//  AudioRecorder
//
//  Created by Вадим Суходольский on 09/04/2018.
//  Copyright © 2018 Вадим Суходольский. All rights reserved.
//

import UIKit

class MicrophoneActivityIndicatorView: UIView {
  
    private let replicator = CAReplicatorLayer()
    private let dot = CALayer()
    private var lastTransformScale: CGFloat = 0
    
    private var dotFrame: CGRect {
        let x = replicator.frame.width - Parameters.dotLenght
        let y = replicator.frame.height/2
        return CGRect(x: x, y: y, width: Parameters.dotLenght, height: Parameters.dotLenght)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupReplicatorLayer()
        setupDotLayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupReplicatorLayer()
        setupDotLayer()
    }
    
    private func setupReplicatorLayer() {
        replicator.frame = self.bounds
        replicator.instanceCount = Int(self.frame.width / Parameters.dotOffset)
        replicator.instanceTransform = CATransform3DMakeTranslation(-Parameters.dotOffset, 0, 0)
        replicator.instanceDelay = 0.02
        self.layer.addSublayer(replicator)
    }
    
    private func setupDotLayer() {
        dot.frame = dotFrame
        dot.backgroundColor = UIColor.lightGray.cgColor
        dot.borderColor = UIColor(white: 1.0, alpha: 1.0).cgColor
        dot.cornerRadius = Parameters.dotCornerRadius
        dot.borderWidth = Parameters.dotBorderWidth
        replicator.addSublayer(dot)
    }
    
    private func addScaleAnimation() {
        let scale = CABasicAnimation(keyPath: "transform")
        scale.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
        scale.toValue = NSValue(caTransform3D: CATransform3DMakeScale(1.4, 15, 1.0))
        scale.duration = 0.33
        scale.repeatCount = .infinity
        scale.autoreverses = true
        scale.timingFunction = CAMediaTimingFunction(name:
            kCAMediaTimingFunctionEaseOut)
        dot.add(scale, forKey: "dotScale")
    }
    
    private func addOpacityAnimation() {
        let fade = CABasicAnimation(keyPath: "opacity")
        fade.fromValue = 1.0
        fade.toValue = 0.2
        fade.duration = 0.33
        fade.beginTime = CACurrentMediaTime() + 0.33
        fade.repeatCount = .infinity
        fade.autoreverses = true
        fade.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        dot.add(fade, forKey: "dotOpacity")
    }
    
   private func addTintAnimation() {
        let tint = CABasicAnimation(keyPath: "backgroundColor")
        tint.fromValue = UIColor.magenta.cgColor
        tint.toValue = UIColor.cyan.cgColor
        tint.duration = 0.66
        tint.beginTime = CACurrentMediaTime() + 0.28
        tint.fillMode = kCAFillModeBackwards
        tint.repeatCount = Float.infinity
        tint.autoreverses = true
        tint.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        dot.add(tint, forKey: "dotColor")
    }
    
    
    private func animateToIntialState() {
        replicator.removeAllAnimations()
        dot.removeAllAnimations()
        let scale = CABasicAnimation(keyPath: "transform")
        scale.toValue = NSValue(caTransform3D: CATransform3DIdentity)
        scale.duration = 0.33
        scale.isRemovedOnCompletion = false
        scale.fillMode = kCAFillModeForwards
        dot.add(scale, forKey: nil)
        
    }
    
    func starAnimating() {
        addScaleAnimation()
        addOpacityAnimation()
        addTintAnimation()
    }
    
    func stopAnimating() {
        animateToIntialState()
    }
    
    func react(to microphoneLevel: Float) {
        let scaleFactor = max(0.2, CGFloat(microphoneLevel) + 50) / 2
        let scale = CABasicAnimation(keyPath: "transform.scale.y")
        scale.fromValue = self.lastTransformScale
        scale.toValue = scaleFactor
        scale.duration = 0.1
        scale.isRemovedOnCompletion = false
        scale.fillMode = kCAFillModeForwards
        self.lastTransformScale = scaleFactor
        self.dot.add(scale, forKey: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupReplicatorLayer()
        setupDotLayer()
    }
 
    struct Parameters {
       static let dotLenght: CGFloat = 6.0
       static let dotOffset: CGFloat = 6.0
       static let dotBorderWidth: CGFloat = 0.5
       static let dotCornerRadius: CGFloat = 1.5
       static let instanceDelay = 0.02
    }

}
