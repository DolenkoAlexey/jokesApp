//
//  EmailValideType.swift
//  jokes
//
//  Created by Alex Dolenko on 07/10/2017.
//  Copyright © 2017 Alex Dolenko. All rights reserved.
//

import Foundation
import RxSwift

protocol EmailValideType {
    var email: Variable<String> { get }
    var isEmailValid : Observable<Bool> { get }
}

extension EmailValideType {
    var isEmailValid : Observable<Bool> {
        return email.validate(by: Constants.RequiredFieldsLenght.email)
    }
}
