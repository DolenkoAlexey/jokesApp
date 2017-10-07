//
//  File.swift
//  jokes
//
//  Created by Alex Dolenko on 07/10/2017.
//  Copyright © 2017 Alex Dolenko. All rights reserved.
//

import Foundation
import RxSwift

protocol UsernameValideType {
    var username: Variable<String> { get }
    var isUsernameValid : Observable<Bool> { get }
}

extension UsernameValideType {
    var isUsernameValid : Observable<Bool> {
        return username.validate(by: Constants.RequiredFieldsLenght.username)
    }
}
