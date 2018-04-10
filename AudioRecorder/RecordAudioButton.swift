//
//  RecordingButton.swift
//  AudioRecorder
//
//  Created by Вадим Суходольский on 09/04/2018.
//  Copyright © 2018 Вадим Суходольский. All rights reserved.
//

import UIKit

class RecordAudioButton: UIButton {
    
    //Square or circle
    private var recordStateFigure = CAShapeLayer()
    
    override var isSelected: Bool {
        didSet {
            let morph = CABasicAnimation(keyPath: "path")
            morph.duration = 0.4
            morph.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            morph.toValue = self.currentPathForRecordStateFigure
            morph.fillMode = kCAFillModeForwards
            morph.isRemovedOnCompletion = false
            self.recordStateFigure.add(morph, forKey: nil)
        }
    }
    
    private var currentPathForRecordStateFigure: CGPath {
        return isSelected ? squareFigurePath : circleFigurePath
    }
    
    private var circleFigurePath: CGPath {
        let path = UIBezierPath(roundedRect: CGRect(origin: Parameters.circleFigureOrigin,
                                                    size: Parameters.circleFigureSize),
                                                    cornerRadius: Parameters.circleFigureCornerRadius)
        return path.cgPath
    }
    
    private var squareFigurePath: CGPath {
        let path = UIBezierPath(roundedRect: CGRect(origin: Parameters.squareFigureOrigin,
                                                    size: Parameters.squareFigureSize),
                                cornerRadius: Parameters.squareFigureCornerRadius)
        return path.cgPath
    }
    
    private var pathForBorderRing: UIBezierPath {
        let path = UIBezierPath(ovalIn: CGRect(origin: Parameters.borderRingOrigin,
                                               size: Parameters.borderRingSize))
        path.lineWidth = Parameters.borderRingLineWidth
        return path
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        setupConstraints()
    }

    private func setup() {
        recordStateFigure.path = currentPathForRecordStateFigure
        recordStateFigure.strokeColor = nil
        recordStateFigure.fillColor = UIColor.red.cgColor
        self.layer.addSublayer(recordStateFigure)
        self.setTitle("", for: UIControlState.normal)
        self.addTarget(self, action: #selector(touchUpInside(_:)), for: .touchUpInside)
        self.addTarget(self, action: #selector(touchDown(_:)), for: .touchDown)
    }
    
    private func setupConstraints() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: Parameters.buttonSize.width).isActive = true
        self.heightAnchor.constraint(equalToConstant: Parameters.buttonSize.height).isActive = true
    }
    
    override func draw(_ rect: CGRect) {
        UIColor.white.setStroke()
        pathForBorderRing.stroke()
    }
    
    @objc func touchDown(_ sender: UIButton) {
        let morph = CABasicAnimation(keyPath: "fillColor")
        morph.duration = 0.4
        morph.toValue = UIColor(red: 1, green: 0, blue: 0, alpha: 0.5).cgColor
        morph.fillMode = kCAFillModeForwards
        morph.isRemovedOnCompletion = false
        morph.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        self.recordStateFigure.add(morph, forKey: nil)

    }
    
    @objc func touchUpInside(_ sender :UIButton) {
        let colorChange = CABasicAnimation(keyPath: "fillColor")
        colorChange.duration = 0.4
        colorChange.toValue = UIColor.red.cgColor
        colorChange.fillMode = kCAFillModeForwards
        colorChange.isRemovedOnCompletion = false
        colorChange.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        self.recordStateFigure.add(colorChange, forKey: nil)
        isSelected = !isSelected
    }
    
    struct Parameters {
        static let circleFigureSize: CGSize = CGSize(width: 50, height: 50)
        static let circleFigureOrigin: CGPoint = CGPoint(x: 8, y: 8)
        static let circleFigureCornerRadius: CGFloat = 25
        static let squareFigureSize: CGSize = CGSize(width: 30, height: 30)
        static let squareFigureOrigin: CGPoint = CGPoint(x: 18, y: 18)
        static let squareFigureCornerRadius: CGFloat = 4
        static let buttonSize = CGSize(width: 66, height: 66)
        static let borderRingOrigin = CGPoint(x: 3, y: 3)
        static let borderRingSize = CGSize(width: 60, height: 60)
        static let borderRingLineWidth: CGFloat = 6
    }
}
