//
//  Variable+validatingBySymbolsCount.swift
//  jokes
//
//  Created by Alex Dolenko on 07/10/2017.
//  Copyright © 2017 Alex Dolenko. All rights reserved.
//

import Foundation
import RxSwift

extension Variable where Element == String {
    func validate(by sybmolsCount: Int) -> Observable<Bool> {
        return self.asObservable().map { $0.characters.count > sybmolsCount}
    }
}
