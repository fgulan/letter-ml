//
//  LetterRecognizer.swift
//  LetterML
//
//  Created by Filip Gulan on 22/09/2017.
//  Copyright © 2017 Filip Gulan. All rights reserved.
//

import UIKit
import Vision

typealias Prediction = (letter: String, prob: Double)

class LetterRecognizer {
    
    private static let inputSize = CGSize(width: 30, height: 30)

    private let minDistance = 0.1
    let model = LetterClass_image()
    
    func recognize(_ image: UIImage?, completion: (Result<Prediction>) -> ()) {
        guard let buffer = image?.pixelBuffer(size: LetterRecognizer.inputSize) else {
            completion(.error("Unable to create buffer!"))
            return
        }
        
        guard let prediction = try? model.prediction(image: buffer) else {
            completion(.error("Unable to make prediction!"))
            return
        }
        print(prediction.letter)
        completion(.success(top(prediction.letter)[0]))
    }
    
    func recognizeWithVision(_ image: UIImage?, completion: @escaping (Result<Prediction>) -> ()) {
        guard let visionModel = try? VNCoreMLModel(for: model.model) else { return }
        
        let classificationRequest = VNCoreMLRequest(model: visionModel) {
            request, error in
            if let observations = request.results as? [VNClassificationObservation] {
                let best = observations[0]
                completion(.success(Prediction(letter: best.identifier, prob: Double(best.confidence))))
            }
        }
        
        let handler = VNImageRequestHandler(cgImage: (image?.cgImage)!)
        try? handler.perform([classificationRequest])
    }
    
    func top(_ prob: [String: Double], _ k: Int = 2) -> [Prediction] {
        precondition(k <= prob.count)
        return Array(prob.map { x in (x.key, x.value) }
            .sorted(by: { a, b -> Bool in a.1 > b.1 })
            .prefix(through: k - 1))
    }
}
