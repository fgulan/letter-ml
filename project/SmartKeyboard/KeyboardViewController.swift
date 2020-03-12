//
//  KeyboardViewController.swift
//  SmartKeyboard
//
//  Created by Filip Gulan on 25/09/2017.
//  Copyright © 2017 Filip Gulan. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController {

    @IBOutlet var keyboardView: SmartKeyboard!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadInterface()
    }
    
    private func loadInterface() {
        let keyboardNib = UINib(nibName: "SmartKeyboard", bundle: nil)
        keyboardView = keyboardNib.instantiate(withOwner: self, options: nil).first as? SmartKeyboard
        keyboardView.delegate = self
        keyboardView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(keyboardView)
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        NSLayoutConstraint.activate([
            keyboardView.topAnchor.constraint(equalTo: view.topAnchor),
            keyboardView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            keyboardView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            keyboardView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            keyboardView.heightAnchor.constraint(equalToConstant: 220)
        ])
    }
    
    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
    }
}

extension KeyboardViewController: SmartKeyboardDelegate {
    
    func keyboard(_ keyboard: SmartKeyboard, didInputText text: String?) {
        guard let text = text else { return }
        textDocumentProxy.insertText(text)
    }
    
    func keyboardDidRemoveLastInput(_ keyboard: SmartKeyboard) {
        textDocumentProxy.deleteBackward()
    }
    
    func keyboardDidRequestNextKeyboard(_ keyboard: SmartKeyboard) {
        advanceToNextInputMode()
    }
    
    func keyboardDidRequestReturn(_ keyboard: SmartKeyboard) {
        textDocumentProxy.insertText("\n")
    }
}
