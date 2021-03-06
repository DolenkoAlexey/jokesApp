//
//  Constants.swift
//  jokes
//
//  Created by Alex Dolenko on 06/10/2017.
//  Copyright © 2017 Alex Dolenko. All rights reserved.
//

import Foundation

struct Constants {
    struct Firebase {
        static let baseUrl = "https://jokes-d3d76.firebaseio.com/"
    }
    
    struct TableViewCellIdentifiers {
        static let Joke = "JokeTableViewCell"
    }
    
    struct ViewControllerIdentifiers {
        static let Login = "Login"
    }
    
    struct SegueIdentifiers {
        static let NewUserLoggedIn = "NewUserLoggedInSegueIdentifier"
        static let LogIn = "LogInSegueIdentifier"
        static let AddJoke = "AddJokeSegueIdentifier"
        static let SignUp = "SignUpSegueIdentifier"
    }
    
    struct RequiredFieldsLenght {
        static let username = 5
        static let password = 6
        static let email = 6
        static let jokeText = 10
    }
}
