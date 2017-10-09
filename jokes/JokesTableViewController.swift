//
//  JokesTableViewController.swift
//  jokes
//
//  Created by Alex Dolenko on 08/10/2017.
//  Copyright © 2017 Alex Dolenko. All rights reserved.
//

import UIKit
import FirebaseAuth
import RxSwift
import RxCocoa

class JokesTableViewController: UITableViewController {

    @IBAction func LogOut(_ sender: UIBarButtonItem) {
        try? Auth.auth().signOut()
        
        let loginViewController = storyboard?.instantiateViewController(withIdentifier: Constants.ViewControllerIdentifiers.Login) as? LoginPageViewController
        loginViewController?.viewModel = LoginViewModel()
        UIApplication.shared.keyWindow?.rootViewController = loginViewController
        
        dismiss(animated: true)
    }
    
    var viewModel: JokesViewModelType!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableViewAutomaticDimension
        
        setup()
    }
    
    private func setup() {
        tableView.delegate = nil
        tableView.dataSource = nil
        
        viewModel.getJokes()
            .map {[weak self] result -> [Joke] in
                switch result {
                case .Success(let joke):
                    return joke
                case .Error(let error):
                    UIAlertController.showErrorAlert(error.localizedDescription, context: self)
                    return []
                }
            }
            .filterEmpty()
            .drive(tableView.rx.items(
                cellIdentifier: Constants.TableViewCellIdentifiers.Joke,
                cellType: JokeTableViewCell.self)
            ) { index, joke, cell in
                cell.viewModel = self.viewModel.getJokeViewModel(by: joke)
            }.disposed(by: disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SegueIdentifiers.AddJoke,
            let addJokeViewController = (segue.destination as? UINavigationController)?.viewControllers[0] as?  AddJokeViewController {
            
            addJokeViewController.viewModel = AddJokeViewModel()
        }
    }
    
    @IBAction func cancel(_ segue: UIStoryboardSegue) { }
}
