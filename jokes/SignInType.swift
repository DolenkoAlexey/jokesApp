//
//  SignInType.swift
//  jokes
//
//  Created by Alex Dolenko on 07/10/2017.
//  Copyright © 2017 Alex Dolenko. All rights reserved.
//

import Foundation
import RxCocoa
import FirebaseAuth

protocol SignInType: CreateUserType {
    func signIn(withEmail email: String, andPassword password: String) -> Driver<Result<User>>
}

extension SignInType {
    func signIn(withEmail email: String, andPassword password: String) -> Driver<Result<User>> {
        return createUserFor(email: email, password: password, method: Auth.auth().signIn)
    }
}
