//
//  Result.swift
//  jokes
//
//  Created by Alex Dolenko on 07/10/2017.
//  Copyright © 2017 Alex Dolenko. All rights reserved.
//

import Foundation

enum Result<T> {
    case Success(T)
    case Error(JokeError)
}

