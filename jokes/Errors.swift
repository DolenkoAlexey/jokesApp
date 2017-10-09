//
//  Errors.swift
//  jokes
//
//  Created by Alex Dolenko on 08/10/2017.
//  Copyright © 2017 Alex Dolenko. All rights reserved.
//

import Foundation

enum JokeError: Error {
    typealias UID = String
    case UserNotFound(UID)
    case UserNotAuthenticated()
    case UnknownError(Error)
    case JokesNotFound
    case CannotGetJoke
    
    var localizedDescription: String {
        switch self {
        case .UserNotFound(let uid):
            return "User with uid \(uid) not found"
        case .UserNotAuthenticated():
            return "User not authenticated"
        case .UnknownError(let error):
            return error.localizedDescription
        case .JokesNotFound:
            return "Jokes not found"
        case .CannotGetJoke:
            return "Cannot get joke"
        }
    }
}
