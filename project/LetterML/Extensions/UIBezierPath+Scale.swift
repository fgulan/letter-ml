//
//  UIBezierPath+Scale.swift
//  LetterML
//
//  Created by Filip Gulan on 01/10/2017.
//  Copyright © 2017 Filip Gulan. All rights reserved.
//

import UIKit

extension UIBezierPath {
    
    // Disaster, needs to be refactored
    func scaleForRect(_ rect: CGRect, offset: CGFloat) {
        let size: CGFloat
        let greaterWidth = self.bounds.width > self.bounds.height
        if greaterWidth {
            size = self.bounds.width
        } else {
            size = self.bounds.height
        }
        let factor = (rect.width - 2 * offset) / size
        scaleAroundCenter(factor: factor, offset: offset)
        let newSize = bounds.size
        
        let diff: CGPoint
        if greaterWidth {
            let diffY = ((rect.width - 2 * offset) - newSize.height) / 2
            diff = CGPoint(x: 0, y: diffY)
        } else {
            let diffX = ((rect.width - 2 * offset) - newSize.width) / 2
            diff = CGPoint(x: diffX, y: 0)
        }
        let translateTransform = CGAffineTransform(translationX: diff.x, y: diff.y)
        self.apply(translateTransform)
    }
    
    func scaleAroundCenter(factor: CGFloat, offset: CGFloat) {
        let scaleTransform = CGAffineTransform(scaleX: factor, y: factor)
        self.apply(scaleTransform)
        
        let diff = CGPoint(
            x: offset - bounds.origin.x,
            y: offset - bounds.origin.y)
        
        let translateTransform = CGAffineTransform(translationX: diff.x, y: diff.y)
        self.apply(translateTransform)
    }
}

extension CGRect {
    
    var center: CGPoint {
        return CGPoint(x: self.midX, y: self.midY)
    }
}
