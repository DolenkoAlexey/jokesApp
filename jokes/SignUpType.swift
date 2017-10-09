//
//  SignUpType.swift
//  jokes
//
//  Created by Alex Dolenko on 07/10/2017.
//  Copyright © 2017 Alex Dolenko. All rights reserved.
//

import Foundation
import FirebaseAuth
import RxCocoa

protocol SignUpType: CreateUserType {
    func signIn(withEmail email: String, andPassword password: String) -> Driver<Result<User>>
}

extension SignUpType {
    func signUp(withEmail email: String, andPassword password: String) -> Driver<Result<User>> {
        return createUserFor(email: email, password: password, method: Auth.auth().createUser)
    }
}
