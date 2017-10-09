//
//  DataService.swift
//  jokes
//
//  Created by Alex Dolenko on 06/10/2017.
//  Copyright © 2017 Alex Dolenko. All rights reserved.
//

import Foundation
import Firebase


class DataService {
    static let sharedInstance = DataService()
    
    let baseRef: DatabaseReference
    let usersRef: DatabaseReference
    let jokesRef: DatabaseReference
    
    private init() {
        self.baseRef = Database.database().reference()
        self.usersRef = baseRef.child("/users")
        self.jokesRef = baseRef.child("/jokes")
    }
    
    func createNewAccount(uid: String, user: Dictionary<String, String>) {
        usersRef.child(uid).setValue(user)
    }
    
    func createNewJoke(joke: Dictionary<String, Any>) {
        let newJoke = jokesRef.childByAutoId()
        newJoke.setValue(joke)
    }
}
