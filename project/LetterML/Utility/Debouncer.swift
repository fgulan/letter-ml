//
//  Debouncer.swift
//  LetterML
//
//  Created by Filip Gulan on 01/10/2017.
//  Copyright © 2017 Filip Gulan. All rights reserved.
//

import Foundation

public class Debouncer: NSObject {
    var callback: (() -> ())
    var delay: Double
    weak var timer: Timer?
    
    init(delay: Double, callback: @escaping (() -> ())) {
        self.delay = delay
        self.callback = callback
    }
    
    func call() {
        timer?.invalidate()
        let nextTimer = Timer.scheduledTimer(timeInterval: delay, target: self, selector: #selector(Debouncer.fireNow), userInfo: nil, repeats: false)
        timer = nextTimer
    }
    
    @objc func fireNow() {
        self.callback()
    }
}

