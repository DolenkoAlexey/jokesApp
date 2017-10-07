//
//  CreateUserViewModel.swift
//  jokes
//
//  Created by Alex Dolenko on 06/10/2017.
//  Copyright © 2017 Alex Dolenko. All rights reserved.
//

import RxCocoa
import RxSwift
import Firebase
import FirebaseAuth

protocol CreateAccountViewModelType: SignInType, SignUpType, UsernameValideType, EmailValideType, PasswordValideType, PasswordAgainValideType, IsAllValidType {
    
    var arePasswordsEqual : Observable<Bool> { get }
}



struct CreateAccountViewModel: CreateAccountViewModelType {
    let username = Variable<String>("")
    let email = Variable<String>("")
    let password = Variable<String>("")
    let passwordAgain = Variable<String>("")
    
    
    var arePasswordsEqual: Observable<Bool> {
        return Observable.combineLatest(password.asObservable(), passwordAgain.asObservable()) { $0 == $1 }
    }
    
    var isAllValid: Observable<Bool> {
        return Observable.combineLatest(
            isUsernameValid,
            isEmailValid,
            isPasswordValid,
            isPasswordAgainValid,
            arePasswordsEqual
        ) { $0 && $1 && $2 && $3 && $4 }
    }
}
