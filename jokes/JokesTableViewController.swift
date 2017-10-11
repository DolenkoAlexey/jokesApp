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
    private var jokes = [Joke]()

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
        tableView.delegate = self
        tableView.dataSource = self
        
        viewModel.getJokes()
            .map {[weak self] result -> [Joke] in
                switch result {
                case .Success(let jokes):
                    return jokes
                case .Error(let error):
                    UIAlertController.showErrorAlert(error.localizedDescription, context: self)
                    return []
                }
            }
            .filterEmpty()
            .drive(onNext: {[weak self] newJokes in
                self?.insert(newJokes: newJokes)
            }).disposed(by: disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SegueIdentifiers.AddJoke,
            let addJokeViewController = (segue.destination as? UINavigationController)?.viewControllers[0] as?  AddJokeViewController {
            
            addJokeViewController.viewModel = AddJokeViewModel()
        }
    }
    
    @IBAction func cancel(_ segue: UIStoryboardSegue) { }
}

extension JokesTableViewController {
    func insert(newJokes: [Joke]) {
        jokes.insert(contentsOf: newJokes, at: 0)
        
        let indeces = newJokes.enumerated().map { (jokeIndex, _)  in  IndexPath(row: jokeIndex, section: 0) }
        
        tableView.beginUpdates()
        tableView.insertRows(at: indeces, with: .automatic)
        tableView.endUpdates()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jokes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifiers.Joke, for: indexPath) as? JokeTableViewCell {
            
            cell.viewModel = self.viewModel.getJokeViewModel(by: jokes[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
}
