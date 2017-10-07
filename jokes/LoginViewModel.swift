//
//  LoginViewModel.swift
//  jokes
//
//  Created by Alex Dolenko on 07/10/2017.
//  Copyright © 2017 Alex Dolenko. All rights reserved.
//

import RxCocoa
import RxSwift
import Firebase
import FirebaseAuth

protocol LoginViewModelType: SignInType, EmailValideType, PasswordValideType, IsAllValidType {  }

struct LoginViewModel: LoginViewModelType {
    let email = Variable<String>("")
    let password = Variable<String>("")

    var isAllValid: Observable<Bool> {
        return Observable.combineLatest(
            isEmailValid,
            isPasswordValid
        ) { $0 && $1 }
    }
}

