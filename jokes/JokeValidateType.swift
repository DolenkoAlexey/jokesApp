//
//  JokeValidateType.swift
//  jokes
//
//  Created by Alex Dolenko on 08/10/2017.
//  Copyright © 2017 Alex Dolenko. All rights reserved.
//

import Foundation
import RxSwift

protocol JokeValidateType {
    var jokeText: Variable<String> { get }
    var isJokeValid : Observable<Bool> { get }
}

extension JokeValidateType {
    var isJokeValid: Observable<Bool> {
        return jokeText.validate(by: Constants.RequiredFieldsLenght.jokeText)
    }
}
