//
//  GetCurrentUserType.swift
//  jokes
//
//  Created by Alex Dolenko on 09/10/2017.
//  Copyright © 2017 Alex Dolenko. All rights reserved.
//

import FirebaseAuth
import RxSwift
import RxCocoa

protocol GetCurrentUserType: GetUserType {
    var currentUser: Driver<Result<UserModel>> { get }
}

extension GetCurrentUserType {
    var currentUser: Driver<Result<UserModel>> {
        if let uid = Auth.auth().currentUser?.uid {
            return getUser(by: uid)
        }
        return .just(.Error(.UserNotAuthenticated()))
    }
    
}
