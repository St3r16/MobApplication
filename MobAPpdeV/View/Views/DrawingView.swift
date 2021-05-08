//
//  DrawingView.swift
//  MobAPpdeV
//
//  Created by sterbro on 4/25/21.
//

import UIKit

class GraphicView: UIView {
    
    private var zeroPoint: CGPoint {
        return CGPoint(x: bounds.width / 2, y: bounds.height / 2)
    }
    
    private var maxPoint: CGPoint {
        return CGPoint(x: bounds.maxX - 10 - frame.minX, y: bounds.minY + 10)
    }
    
    private var minPoint: CGPoint {
        return CGPoint(x: bounds.minX + 10, y: bounds.maxY - 10 - frame.minY)
    }
    
    private var scaleFactor: CGFloat = 15.0
    
    func function(x: Double) -> Double {
        return sin(x)
    }
    
    private let interval: ClosedRange = -2 * Double.pi...2 * .pi
    
    private func drawGrid() {
        
        let path = UIBezierPath()
        
        // horizontal grid
        for i in -6...6 {
            path.move(to: CGPoint(x: minPoint.x, y: zeroPoint.y + CGFloat(i) * scaleFactor))
            path.addLine(to: CGPoint(x: maxPoint.x, y: zeroPoint.y + CGFloat(i) * scaleFactor))
        }
        
        // vertical grid
        for i in -6...6 {
            path.move(to: CGPoint(x: zeroPoint.x - CGFloat(i) * scaleFactor, y: maxPoint.y))
            path.addLine(to: CGPoint(x: zeroPoint.x - CGFloat(i) * scaleFactor, y: minPoint.y))
        }
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.name = "DrawingLayerGrid"
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.green.cgColor
        shapeLayer.fillColor = .none
        shapeLayer.lineWidth = 0.2
        
        layer.addSublayer(shapeLayer)
        
    }
    
    private func drawAxis() {
        let path = UIBezierPath()
        
        // Oy-axis
        path.move(to: CGPoint(x: zeroPoint.x, y: maxPoint.y))
        path.addLine(to: CGPoint(x: zeroPoint.x, y: minPoint.y))
        
        for i in -6...6 {
            path.move(to: CGPoint(x: zeroPoint.x + CGFloat(i) * scaleFactor, y: zeroPoint.y - 2))
            path.addLine(to: CGPoint(x: zeroPoint.x + CGFloat(i) * scaleFactor, y: zeroPoint.y + 2))
        }
        
        for i in [-1, 1] {
            path.move(to: CGPoint(x: zeroPoint.x, y: maxPoint.y))
            path.addLine(to: CGPoint(x: zeroPoint.x + CGFloat(i) * 3, y: maxPoint.y + 5))
        }
        
        // Ox-axis
        path.move(to: CGPoint(x: minPoint.x, y: zeroPoint.y))
        path.addLine(to: CGPoint(x: maxPoint.x, y: zeroPoint.y))
        
        for i in -6...6 {
            path.move(to: CGPoint(x: zeroPoint.x - 2, y: zeroPoint.y + CGFloat(i) * scaleFactor))
            path.addLine(to: CGPoint(x: zeroPoint.x + 2, y: zeroPoint.y + CGFloat(i) * scaleFactor))
        }
        
        for i in [-1, 1] {
            path.move(to: CGPoint(x: maxPoint.x, y: zeroPoint.y))
            path.addLine(to: CGPoint(x: maxPoint.x - 5, y: zeroPoint.y + CGFloat(i) * 3))
        }
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.name = "DrawingLayerAxis"
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.fillColor = .none
        shapeLayer.lineWidth = 1.0
        
        layer.addSublayer(shapeLayer)
    }
    
    private func _drawGraphic() {
        
        let path = UIBezierPath()
        
        let startX = interval.lowerBound
        var point = CGPoint(x: zeroPoint.x + CGFloat(startX) * scaleFactor,
                            y: zeroPoint.y - CGFloat(function(x: Double(startX))) * scaleFactor)
        
        var isInBounds: Bool = false
        var pointSet: Bool = false
        
        for x in stride(from: Double(interval.lowerBound),
                        through: Double(interval.upperBound),
                        by: 0.01) {
            
            isInBounds = bounds.contains(point)
            
            if isInBounds && !pointSet {
                pointSet = true
                path.move(to: point)
            }
        
            
            let dx = CGFloat(x) * scaleFactor
            let dy = CGFloat(function(x: x)) * scaleFactor
            
            point.x = zeroPoint.x + dx
            point.y = zeroPoint.y - dy
            
            if isInBounds && pointSet {
                path.addLine(to: point)
            }
        }
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.name = "DrawingLayerGraphic"
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.blue.cgColor
        shapeLayer.fillColor = .none
        shapeLayer.lineWidth = 1.0
        
        layer.addSublayer(shapeLayer)
        
    }
    
    private func clearUp() {
        if let sublayers = layer.sublayers {
            for layer in sublayers {
                layer.removeFromSuperlayer()
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        draw(self.bounds)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawGraphic()
    }

    private func drawGraphic() {
        clearUp()
        drawGrid()
        drawAxis()
        _drawGraphic()
    }
    
}
