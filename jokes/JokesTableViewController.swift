//
//  JokesTableViewController.swift
//  jokes
//
//  Created by Alex Dolenko on 08/10/2017.
//  Copyright © 2017 Alex Dolenko. All rights reserved.
//

import UIKit
import FirebaseAuth

class JokesTableViewController: UITableViewController {

    @IBAction func LogOut(_ sender: UIBarButtonItem) {
        try? Auth.auth().signOut()
        
        let loginViewController = storyboard?.instantiateViewController(withIdentifier: Constants.ViewControllerIdentifiers.Login) as? LoginPageViewController
        loginViewController?.viewModel = LoginViewModel()
        UIApplication.shared.keyWindow?.rootViewController = loginViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    private func setup() {
        
    }
}
