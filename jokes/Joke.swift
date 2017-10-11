//
//  Joke.swift
//  jokes
//
//  Created by Alex Dolenko on 08/10/2017.
//  Copyright © 2017 Alex Dolenko. All rights reserved.
//

import Firebase
import FirebaseDatabase

struct Joke {
    let jokeRef: DatabaseReference
    
    let key: String
    let text: String
    var votes: Int
    let username: String
    
    init(key: String, votes: Int, text: String, username: String) {
        self.key = key
        self.votes = votes
        self.text = text
        self.username = username
        self.jokeRef = DataService.sharedInstance.jokesRef.child(self.key)
    }
}
