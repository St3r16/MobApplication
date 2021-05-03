//
//  DiagramView.swift
//  MobAPpdeV
//
//  Created by sterbro on 4/25/21.
//

import UIKit

class DiagramView: UIView {
    
    private var zeroPoint: CGPoint {
        return CGPoint(x: frame.width / 2, y: frame.height / 2)
    }
    
    private let colors: [(UIColor, CGFloat)] = [(.brown, 5/100),
                                                (.systemBlue, 5/100),
                                                (.orange, 10/100),
                                                (.blue, 80/100)]
    
    override func layoutSubviews() {
        super.layoutSubviews()
        draw(self.frame)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawDiagram()
    }
    
    private func _drawDiagram() {
        
        
        var startAngle: CGFloat = -CGFloat.pi / 2
        
        for (color, percent) in colors {

            let path = UIBezierPath()
            let endAngle = startAngle + 2 * CGFloat.pi * percent

            path.addArc(withCenter: zeroPoint,
                        radius: 60,
                        startAngle: startAngle,
                        endAngle: endAngle,
                        clockwise: true)

            startAngle = endAngle

            let shapeLayer = CAShapeLayer()
            shapeLayer.name = "DrawingLayerDiagram"
            shapeLayer.path = path.cgPath
            shapeLayer.strokeColor = color.cgColor
            shapeLayer.fillColor = .none
            shapeLayer.lineWidth = 25

            layer.addSublayer(shapeLayer)
        }
        
    }
    
    private func clearUp() {
        if let sublayers = layer.sublayers {
            for layer in sublayers {
                layer.removeFromSuperlayer()
            }
        }
    }
    
    private func drawDiagram() {
        clearUp()
        _drawDiagram()
    }
    
}
