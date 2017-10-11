//
//  JokeViewModel.swift
//  jokes
//
//  Created by Alex Dolenko on 09/10/2017.
//  Copyright © 2017 Alex Dolenko. All rights reserved.
//

import Foundation
import FirebaseAuth
import RxSwift
import RxCocoa

protocol JokeViewModelType: GetCurrentUserType {
    var joke: Joke { get }
    var likesCount: Driver<String> { get }
    var isUserLikedJoke: Driver<Bool> { get }
    func likeJoke() -> Disposable
}

struct JokeViewModel: JokeViewModelType {
    var isUserLikedJoke: Driver<Bool> {
        return Observable.create { observer -> Disposable in
            guard let uid = Auth.auth().currentUser?.uid else {
                observer.on(.error(JokeError.UserNotAuthenticated()))
                return Disposables.create()
            }
            
            let votesSubscription = DataService.sharedInstance.usersRef.child(uid).child("votes").observe(.value) { snap in
                let isUSerLikedJoke = (snap.value as? [String])?.contains(self.joke.key) ?? false
                
                observer.on(.next(isUSerLikedJoke))
            }
            
            return Disposables.create {
                DataService.sharedInstance.usersRef.removeObserver(withHandle: votesSubscription)
            }
        }.asDriver(onErrorJustReturn: false)
    }
    
    let joke: Joke
    
    var likesCount: Driver<String> {
        return Observable.create { observer in
            let jokeSubscription = self.joke.jokeRef.observe(.childChanged) { snapshot in
                if let votes = snapshot.value as? Int {
                    observer.on(.next("\(votes)"))
                } else {
                    observer.on(.error(JokeError.CannotGetJoke))
                }
            }
            
            return Disposables.create {
                self.joke.jokeRef.removeObserver(withHandle: jokeSubscription)
            }
        }.asDriver(onErrorJustReturn: "-1")
    }
    
    func likeJoke() -> Disposable {
        return currentUser.map { result in
                switch result {
                case .Success(let user):
                    let isUserLikedPostYet = user.votes.contains(self.joke.key)
                    
                    var votes = user.votes
                    var votesCount = self.joke.votes
                    
                    if isUserLikedPostYet {
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
