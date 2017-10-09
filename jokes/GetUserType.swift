//
//  getUserType.swift
//  jokes
//
//  Created by Alex Dolenko on 08/10/2017.
//  Copyright © 2017 Alex Dolenko. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import RxSwift
import RxCocoa

protocol GetUserType {
    func getUser(by uid: String) -> Driver<Result<UserModel>>
}

extension GetUserType {
    func getUser(by uid: String) -> Driver<Result<UserModel>> {
        return Observable.create { observer in
            DataService.sharedInstance.usersRef.child(uid).observeSingleEvent(of: .value, with: { snapshot in
                    guard let userDict = snapshot.value as? [String: Any] else {
                        observer.on(.error(JokeError.UserNotFound(uid)))
                        return 
                    }
            
                    let username = userDict["name"] as? String  ?? "Unknown User"
                    let votes = userDict["votes"] as? [String] ?? []
            
                let user = UserModel(uid: uid, name: username, votes: votes)
            
                    observer.on(.next(.Success(user)))
                    observer.on(.completed)
                }) { error in
                    observer.on(.error(JokeError.UnknownError(error)))
                }
            
                return Disposables.create()
            }.asDriver(onErrorRecover: { error in
                let err = (error is JokeError) ? error as! JokeError:  .UnknownError(error)
                return .just(.Error(err))
            })
    }
}
