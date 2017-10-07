//
//  UITextField+rxıindings.swift
//  jokes
//
//  Created by Alex Dolenko on 07/10/2017.
//  Copyright © 2017 Alex Dolenko. All rights reserved.
//
import RxCocoa
import RxSwift

extension UITextField {
    func bind(to variable: Variable<String>) -> Disposable {
        return self.rx.text.filterNil().bind(to: variable)
    }
    
    func endEditing() -> Observable<Bool> {
        return self.rx.controlEvent([.editingDidEnd]).asObservable().map { true }
    }
}
