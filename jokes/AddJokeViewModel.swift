//
//  AddJokeViewModel.swift
//  jokes
//
//  Created by Alex Dolenko on 08/10/2017.
//  Copyright © 2017 Alex Dolenko. All rights reserved.
//

import FirebaseAuth
import RxSwift
import RxCocoa

protocol AddJokeViewModelType: JokeValidateType, GetCurrentUserType {
    func canPublish() -> Driver<Bool>
    func saveJoke(text: String, username: String)
}

struct AddJokeViewModel: AddJokeViewModelType {
    let jokeText = Variable("")
    
    func canPublish() -> Driver<Bool> {
        let isUserAvailable = currentUser.map { result -> Bool in
            switch result {
            case .Success(_):
                return true
            case .Error(_):
                return false
            }
        }
        
        let isJokeTextValid = isJokeValid.asDriver(onErrorJustReturn: false)
        
        return Driver.combineLatest(isUserAvailable, isJokeTextValid) { $0 && $1 }.startWith(false)
    }
    
    func saveJoke(text: String, username: String) {
        let newJoke: Dictionary<String, Any> = [
            "jokeText": text,
            "votes": 0,
            "author": username
        ]
        
        DataService.sharedInstance.createNewJoke(joke: newJoke)
    }
}
