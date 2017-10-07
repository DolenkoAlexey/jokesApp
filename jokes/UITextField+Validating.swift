//
//  UITextField+Validating.swift
//  jokes
//
//  Created by Alex Dolenko on 07/10/2017.
//  Copyright © 2017 Alex Dolenko. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension UITextField {
    func setFailedValidationState() {
        self.layer.borderColor = UIColor.red.cgColor
    }
    
    func setSucceededValidationState() {
        self.layer.borderColor = UIColor.green.cgColor
    }
    
    func setupBorders() {
        self.layer.cornerRadius = 8.0
        self.layer.masksToBounds = true
        self.layer.borderWidth = 0.5
    }
    
    func setupValidation(to validator: Observable<Bool>) -> Disposable {
        self.setupBorders()
        return self.rx.controlEvent([.editingDidEnd])
            .asObservable()
            .flatMapLatest {
                return validator
            }
            .subscribe(onNext: {[weak self] isFieldValid in
                isFieldValid
                    ? self?.setSucceededValidationState()
                    : self?.setFailedValidationState()
            })
    }
}

extension UILabel {
    func setHidden(to isHidden: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.isHidden = isHidden
        }
    }
}
