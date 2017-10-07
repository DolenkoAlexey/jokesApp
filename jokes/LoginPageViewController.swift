//
//  LoginPageViewController.swift
//  
//
//  Created by Alex Dolenko on 06/10/2017.
//

import UIKit
import RxSwift
import RxCocoa
import FirebaseAuth

class LoginPageViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signinButton: UIButton!
    
    var viewModel: LoginViewModelType!
    
    private let disposeBag = DisposeBag()
    private var fields: [UITextField: Observable<Bool>]!
    
    private var email: String? {
        return emailTextField.text
    }
    
    private var password: String? {
        return passwordTextField.text
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: Constants.SegueIdentifiers.LogIn, sender: nil)
        }
    }
    
    private func setup() {
        setupFields()
        setupBindings()
        setupValidation()
        setupSignInTap()
    }
    
    private func setupFields() {
        fields = [
            emailTextField: viewModel.isEmailValid,
            passwordTextField: viewModel.isPasswordValid,
        ]
    }
    
    private func setupBindings() {
        emailTextField.bind(to: viewModel.email).disposed(by: disposeBag)
        passwordTextField.bind(to: viewModel.password).disposed(by: disposeBag)
    }
    
    private func setupValidation() {
        fields.forEach { field, validator in
            field.setupValidation(to: validator).disposed(by: disposeBag)
        }
        
        viewModel.isAllValid.bind(to: signinButton.rx.isEnabled).disposed(by: disposeBag)
    }
    
    private func setupSignInTap() {
        signinButton.rx.tap.asDriver().flatMap {[unowned self] in
                self.viewModel.signIn(withEmail: self.email!, andPassword: self.password!)
            }.drive(onNext: {[weak self] result in
                switch result {
                case .Success(_):
                    self?.performSegue(withIdentifier: Constants.SegueIdentifiers.LogIn, sender: nil)
                case .Error(let error):
                    UIAlertController.showErrorAlert(error.localizedDescription, context: self)
                }
            }).disposed(by: disposeBag)
    }
    
    
    @IBAction func cancel(_ segue: UIStoryboardSegue) { }
}
