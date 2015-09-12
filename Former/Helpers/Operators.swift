//
//  Operators.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/24/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

infix operator =? {
associativity right
precedence 90
assignment
}

infix operator ?= {
associativity right
precedence 90
assignment
}

internal func =?<T> (inout lhs: T, rhs: T?) {
    
    _ = rhs.map { lhs = $0 }
}

internal func =?<T> (inout lhs: T?, rhs: T?) {
    
    _ = rhs.map { lhs = $0 }
}

internal func =?<T> (inout lhs: T!, rhs: T?) {
    
    _ = rhs.map { lhs = $0 }
}

internal func ?=<T> (inout lhs: T?, rhs: T) {
    
    if lhs == nil {
        lhs = rhs
    }
}

internal func ?=<T> (inout lhs: T?, rhs: T?) {
    
    if lhs == nil {
        lhs = rhs
    }
}