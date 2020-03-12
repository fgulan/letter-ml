//
//  SmartKeyboard.swift
//  SmartKeyboard
//
//  Created by Filip Gulan on 25/09/2017.
//  Copyright © 2017 Filip Gulan. All rights reserved.
//

import UIKit

protocol SmartKeyboardDelegate: class {
    func keyboard(_ keyboard: SmartKeyboard, didInputText text: String?)
    func keyboardDidRemoveLastInput(_ keyboard: SmartKeyboard)
    func keyboardDidRequestNextKeyboard(_ keyboard: SmartKeyboard)
    func keyboardDidRequestReturn(_ keyboard: SmartKeyboard)
}

class SmartKeyboard: UIView {
    
    @IBOutlet weak var canvasView: CanvasView!
    weak var delegate: SmartKeyboardDelegate?
    let recognizer: LetterRecognizer = LetterRecognizer()

    override func awakeFromNib() {
        super.awakeFromNib()
        canvasView.delegate = self
        
        canvasView.layer.cornerRadius = 10
        canvasView.layer.borderWidth = 0.5
        canvasView.layer.borderColor = UIColor.gray.cgColor
        canvasView.layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    @IBAction func clearButtonActionHandler(_ sender: Any) {
        delegate?.keyboardDidRemoveLastInput(self)
    }
    
    @IBAction func nextButtonActionHandler(_ sender: Any) {
        delegate?.keyboardDidRequestNextKeyboard(self)
    }
    
    @IBAction func returnButtonActionHandler(_ sender: Any) {
        delegate?.keyboardDidRequestReturn(self)
    }
}

extension SmartKeyboard: CanvasDelegate {
    
    func canvas(_ canvas: CanvasView, didChangeInput image: UIImage) {
        canvas.clear()
        recognizer.recognize(image) { [weak self] result in
            switch (result) {
            case .success(let prediction):
                let text: String = prediction.letter == "-" ? " " : prediction.letter.lowercased()
                self?.delegate?.keyboard(self!, didInputText: text)
            case .error:
                self?.delegate?.keyboard(self!, didInputText: "")
            }
        }
    }
}
