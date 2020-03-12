//
//  DrawViewController.swift
//  LetterML
//
//  Created by Filip Gulan on 22/09/2017.
//  Copyright © 2017 Filip Gulan. All rights reserved.
//

import UIKit

class DrawViewController: UIViewController {

    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var canvasView: CanvasView!

    let recognizer: LetterRecognizer = LetterRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        canvasView.delegate = self
    }
    
    // MARK: - IB Actions -
    
    @IBAction func recognizeButtonActionHandler(_ sender: Any) {
        let image = canvasView.getImage()
        recognize(image)
    }
    
    private func recognize(_ image: UIImage) {
        recognizer.recognize(image) { [weak self] result in
            switch (result) {
            case .success(let prediction):
                self?.infoLabel.text = "Recognized letter: \(prediction.letter)"
            case .error(let message):
                self?.infoLabel.text = message
            }
        }
    }
    
    @IBAction func resetButtonActionHandler(_ sender: UIButton) {
        canvasView.clear()
    }
}

extension DrawViewController: CanvasDelegate {
    
    func canvas(_ canvas: CanvasView, didChangeInput image: UIImage) {
        recognize(image)
    }
}
