//
//  FSUtils.swift
//  RxSwift-Playground
//
//  Created by Nathan Furman on 1/3/18.
//  Copyright © 2018 Nathan Furman. All rights reserved.
//

import Foundation

class FSUtils {
    
    static public func example(of description: String, action: () -> Void) {
        
        print("\n --- Example of:", description, "---")
        action()
    }
}
