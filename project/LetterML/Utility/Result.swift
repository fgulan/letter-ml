//
//  Result.swift
//  LetterML
//
//  Created by Filip Gulan on 22/09/2017.
//  Copyright © 2017 Filip Gulan. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case error(String)
}
