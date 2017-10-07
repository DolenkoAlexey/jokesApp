//
//  GetUserType.swift
//  jokes
//
//  Created by Alex Dolenko on 07/10/2017.
//  Copyright © 2017 Alex Dolenko. All rights reserved.
//

import Foundation
import FirebaseAuth
import RxCocoa
import RxSwift

protocol GetUserType {
    typealias UserMethod = (_ withEmail: String, _ password: String, _ completion: AuthResultCallback?) -> ()
    func getUserFor(email: String, password: String, method: @escaping UserMethod) -> Driver<Result<User>>
}

extension GetUserType {
    func getUserFor(email: String, password: String, method: @escaping UserMethod) -> Driver<Result<User>> {
        return Observable.create { observer in
                method(email, password) { (user, error) in
                    if error != nil {
                        observer.on(.error(error!))
                    } else {
                        observer.on(.next(.Success(user!)))
                        observer.on(.completed)
                    }
                }
                return Disposables.create()
            }.asDriver(onErrorRecover: { error in
                return .just(.Error(error))
            })
    }
}
