//
//  UIView+Image.swift
//  LetterML
//
//  Created by Filip Gulan on 22/09/2017.
//  Copyright © 2017 Filip Gulan. All rights reserved.
//

import UIKit

extension UIView {
    
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
