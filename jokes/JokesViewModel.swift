//
//  JokesViewModel.swift
//  jokes
//
//  Created by Alex Dolenko on 08/10/2017.
//  Copyright © 2017 Alex Dolenko. All rights reserved.
//

import Firebase
import FirebaseAuth
import RxSwift
import RxCocoa

protocol JokesViewModelType {
    func getJokes() -> Driver<Result<[Joke]>>
    func getJokeViewModel(by joke: Joke) -> JokeViewModelType
}

struct JokesViewModel: JokesViewModelType {
    private let jokes = DataService.sharedInstance.jokesRef
    
    func getJokes() -> Driver<Result<[Joke]>> {
        return Observable.create { observer in
            let getNewJokesSubscription = self.jokes.observe(.value) { snapshot in
                        if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                            let jokes: [Joke] = snapshots.flatMap { self.getJoke(from: $0) }.reversed()
                            
                            observer.on(.next(.Success(jokes)))
                        } else {
                            observer.on(.error(JokeError.JokesNotFound))
                        }
                    }
            
            
                return Disposables.create {
                    self.jokes.removeObserver(withHandle: getNewJokesSubscription)
                }
            }
            .asDriver(onErrorRecover: { error in
                return .just(.Error(.UnknownError(error)))
            })
            .throttle(1.0)
    }
    
    func getJokeViewModel(by joke: Joke) -> JokeViewModelType {
        return JokeViewModel(joke: joke)
    }
    
    private func getJoke(from snapshot: DataSnapshot) -> Joke? {
        guard let post = snapshot.value as? Dictionary<String, Any> else { return nil }
        
        let key = snapshot.key
        let jokeText = post["jokeText"] as? String ?? "Joke not found"
        let votes = post["votes"] as? Int ?? -1
        let username = post["author"] as? String ?? "Unknown author"
        
        return Joke(key: key, votes: votes, text: jokeText, username: username)
    }
}

