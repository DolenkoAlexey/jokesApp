//
//  User.swift
//  jokes
//
//  Created by Alex Dolenko on 08/10/2017.
//  Copyright © 2017 Alex Dolenko. All rights reserved.
//

import Foundation

struct UserModel {
    typealias JokeKey = String
    
    let uid: String
    let name: String
    let votes: [JokeKey]
}
