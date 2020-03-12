//
//  CanvasView.swift
//  LetterML
//
//  Created by Filip Gulan on 22/09/2017.
//  Copyright © 2017 Filip Gulan. All rights reserved.
//

import UIKit

typealias Move = (start: CGPoint, end: CGPoint)

protocol CanvasDelegate: class {
    func canvas(_ canvas: CanvasView, didChangeInput image: UIImage)
}

class CanvasView: UIView {
    
    var strokeWidth: CGFloat = 10 { didSet { setNeedsDisplay() } }
    var strokeColor: UIColor = .gray { didSet { setNeedsDisplay() } }
    private var moves: [Move] = []
    private var lastPoint: CGPoint?
    private var debouncer: Debouncer!
    private var drawing: Bool = false
    private let offset: CGFloat = 25.0

    weak var delegate: CanvasDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        debouncer = Debouncer(delay: 0.3, callback: { [weak self] in
            guard let sself = self else { return }
            if !sself.drawing {
                sself.delegate?.canvas(sself, didChangeInput: sself.getImage())
            } else {
                sself.debouncer.call()
            }
        })
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        drawing = true
        lastPoint = touches.first?.location(in: self)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let lastPoint = lastPoint, let newPoint = touches.first?.location(in: self) else {
            return
        }
        moves.append(Move(start: lastPoint, end: newPoint))
        self.lastPoint = newPoint
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        debouncer.call()
        drawing = false
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let drawPath = UIBezierPath()
        drawPath.lineCapStyle = .round
        
        moves.forEach { (start, end) in
            drawPath.move(to: start)
            drawPath.addLine(to: end)
        }

        drawPath.lineWidth = strokeWidth
        strokeColor.set()
        drawPath.stroke()
    }
    
    func clear() {
        moves = []
        lastPoint = nil
        setNeedsDisplay()
    }
    
    func getImage() -> UIImage {
        let drawPath = UIBezierPath()
        moves.forEach { (start, end) in
            drawPath.move(to: start)
            drawPath.addLine(to: end)
        }
        
        drawPath.scaleForRect(bounds, offset: offset)

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = drawPath.cgPath
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 14.0
        
        let imageLayer = CALayer()
        imageLayer.backgroundColor = UIColor.black.cgColor
        imageLayer.addSublayer(shapeLayer)
        imageLayer.frame = frame
        imageLayer.bounds = bounds
        let renderer = UIGraphicsImageRenderer(bounds: imageLayer.bounds)
        return renderer.image { rendererContext in
            imageLayer.render(in: rendererContext.cgContext)
        }
    }
}
