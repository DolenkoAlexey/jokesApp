//
//  ViewController.swift
//  jokes
//
//  Created by Alex Dolenko on 06/10/2017.
//  Copyright © 2017 Alex Dolenko. All rights reserved.
//

import UIKit
import RxSwift
import RxOptional
import RxCocoa
import FirebaseAuth

class CreateAccountViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordAgainTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var passwordsArentEqualLabel: UILabel!
    
    private var email: String? {
        return emailTextField.text
    }
    
    private var username: String? {
        return userNameTextField.text
    }
    
    private var password: String? {
        return passwordTextField.text
    }
    
    var viewModel: CreateAccountViewModelType! { /// TODO DIP
        didSet {
            fields = [
                emailTextField: viewModel.isEmailValid,
                passwordAgainTextField: viewModel.isPasswordAgainValid,
                passwordTextField: viewModel.isPasswordValid,
                userNameTextField: viewModel.isUsernameValid
            ]
        }
    }
    
    
    private let disposeBag = DisposeBag()
    private var fields: [UITextField: Observable<Bool>]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = CreateAccountViewModel()
        setup()
    }
    
    private func setup() {
        setupBindings()
        setupValidation()
        setupPasswordCheck()
        setupCreateUserButtonTapped()
    }
    
    private func setupBindings() {
        emailTextField.bind(to: viewModel.email).disposed(by: disposeBag)
        passwordTextField.bind(to: viewModel.password).disposed(by: disposeBag)
        passwordAgainTextField.bind(to: viewModel.passwordAgain).disposed(by: disposeBag)
        userNameTextField.bind(to: viewModel.username).disposed(by: disposeBag)
    }
    
    private func setupValidation() {
        fields.forEach { field, validator in
            field.setupValidation(to: validator).disposed(by: disposeBag)
        }
        
        viewModel.isAllValid.bind(to: createAccountButton.rx.isEnabled).disposed(by: disposeBag)
    }
    
    private func setupPasswordCheck() {
        Observable.combineLatest(passwordTextField.endEditing(), passwordAgainTextField.endEditing())
            .map { $0 && $1 }
            .filter { $0 }
            .distinctUntilChanged()
            .flatMap {[unowned self] _ in self.viewModel.arePasswordsEqual }
            .subscribe(onNext: {[weak self] arePasswordsEqual in
                self?.passwordsArentEqualLabel.setHidden(to: arePasswordsEqual)
            }).disposed(by: disposeBag)
    }
    
    
    private func setupCreateUserButtonTapped() {
        createAccountButton.rx.tap.asDriver()
            .flatMapLatest {[unowned self] () -> Driver<Result<User>> in
                return self.viewModel.signUp(withEmail: self.email!, andPassword: self.password!)
            }.flatMapLatest {[unowned self] result -> Driver<Result<User>> in
                switch result {
                case .Success(let _):
                    self.performSegue(withIdentifier: Constants.SegueIdentifiers.NewUserLoggedIn, sender: nil)
                case .Error(let error):
                    UIAlertController.showErrorAlert(error.localizedDescription, context: self)
                }
                
                return self.viewModel.signIn(withEmail: self.email!, andPassword: self.password!)
            }.drive(onNext: {[unowned self] result in
                switch result {
                case .Success(let user):
                    let userdata = ["email": user.email!, "name": self.username!]
                    DataService.sharedInstance.createNewAccount(uid: user.uid, user: userdata)
                case .Error(let error):
                    UIAlertController.showErrorAlert(error.localizedDescription, context: self)
                }
            }).disposed(by: disposeBag)
    }
}
