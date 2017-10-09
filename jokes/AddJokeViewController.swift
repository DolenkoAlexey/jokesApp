//
//  AddJokeViewController.swift
//  jokes
//
//  Created by Alex Dolenko on 08/10/2017.
//  Copyright © 2017 Alex Dolenko. All rights reserved.
//

import UIKit
import FirebaseAuth
import RxSwift
import RxCocoa

class AddJokeViewController: UIViewController {
    
    @IBOutlet weak var jokeTextView: UITextView!
    @IBOutlet weak var publichButton: UIButton!
    
    var jokeText: String {
        return jokeTextView.text
    }
    
    var viewModel: AddJokeViewModelType!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    private func setup() {
        setupBindings()
        setupValidation()
    }
    
    private func setupBindings() {
        jokeTextView.rx.text.filterNil().bind(to: viewModel.jokeText).disposed(by: disposeBag)
        
        publichButton.rx.tap.asDriver().flatMapLatest {[unowned self] _ in
                self.viewModel.currentUser
            }.drive(onNext: {[unowned self] result in
                switch result {
                case .Success(let user):
                    self.viewModel.saveJoke(text: self.jokeText, username: user.name)
                    self.dismiss(animated: true, completion: nil)
                case .Error(let error):
                    UIAlertController.showErrorAlert(error.localizedDescription, context: self)
                }
            }).disposed(by: disposeBag)
    }
    
    private func setupValidation() {
        viewModel.canPublish().drive(publichButton.rx.isEnabled).disposed(by: disposeBag)
    }
}
