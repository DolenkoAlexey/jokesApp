//
//  JokeViewModel.swift
//  jokes
//
//  Created by Alex Dolenko on 09/10/2017.
//  Copyright © 2017 Alex Dolenko. All rights reserved.
//

import RxSwift
import RxCocoa

protocol JokeViewModelType: GetCurrentUserType {
    var joke: Joke { get }
    var isUserLikedJoke: Driver<Bool> { get }
    func likeJoke() -> Disposable
}

struct JokeViewModel: JokeViewModelType {
    var isUserLikedJoke: Driver<Bool> {
        return currentUser.map { result in
            switch result {
            case .Success(let user):
                return user.votes.contains(self.joke.key)
            case .Error(_):
                return false
            }
        }
    }
    
    let joke: Joke
    
    func likeJoke() -> Disposable {
        return currentUser.map { result in
                switch result {
                case .Success(let user):
                    let isUserLikedPost = user.votes.contains(self.joke.key)
                    
                    var votes = user.votes
                    var votesCount = self.joke.votes
                    
                    if isUserLikedPost {
                        votesCount -= 1
                        votes.remove(at: votes.index(of: self.joke.key)!)
                    } else {
                        votesCount += 1
                        votes.append(self.joke.key)
                    }
                    
                    self.joke.jokeRef.child("votes").setValue(votesCount)
                    DataService.sharedInstance.usersRef.child(user.uid).child("votes").setValue(votes)
                    
                case .Error(let error):
                    print(error)
                }
            }.drive()
    }
    
}
