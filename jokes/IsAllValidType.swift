//
//  IsAllValidType.swift
//  jokes
//
//  Created by Alex Dolenko on 07/10/2017.
//  Copyright © 2017 Alex Dolenko. All rights reserved.
//

import Foundation
import RxSwift

protocol IsAllValidType {
    var isAllValid : Observable<Bool> { get }
}
