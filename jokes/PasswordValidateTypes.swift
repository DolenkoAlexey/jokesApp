//
//  PasswordValidateTypes.swift
//  jokes
//
//  Created by Alex Dolenko on 07/10/2017.
//  Copyright © 2017 Alex Dolenko. All rights reserved.
//

import Foundation
import RxSwift


protocol PasswordValideType {
    var password: Variable<String> { get }
    var isPasswordValid : Observable<Bool> { get }
}

extension PasswordValideType {
    var isPasswordValid : Observable<Bool> {
        return password.validate(by: Constants.RequiredFieldsLenght.password)
    }
}


protocol PasswordAgainValideType {
    var passwordAgain: Variable<String> { get }
    var isPasswordAgainValid : Observable<Bool> { get }
}

extension PasswordAgainValideType {
    var isPasswordAgainValid : Observable<Bool> {
        return passwordAgain.validate(by: Constants.RequiredFieldsLenght.password)
    }
}
