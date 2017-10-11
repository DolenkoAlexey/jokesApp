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
        return Observable<Joke>.create { observer in
            let getNewJokesSubscription = self.jokes.observe(.childAdded) { snapshot in
                    if let joke = DataService.sharedInstance.getJoke(from: snapshot) {
                        observer.on(.next(joke))
                    }
                }
            
                return Disposables.create {
                    self.jokes.removeObserver(withHandle: getNewJokesSubscription)
                }
            }
            .buffer(timeSpan: 0.3, count: 10, scheduler: MainScheduler.instance)
            .map { .Success($0.reversed()) }
            .asDriver(onErrorRecover: { error in
                return .just(.Error(.UnknownError(error)))
            })
    }
    
    func getJokeViewModel(by joke: Joke) -> JokeViewModelType {
        return JokeViewModel(joke: joke)
    }
}

