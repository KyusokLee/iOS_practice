//
//  CheckEvenModel.swift
//  UnitTest_practice
//
//  Created by Kyus'lee on 2022/07/07.
//

import Foundation

struct Even {
    let number: Int
    var isEven: Bool {
        get {
            return number % 2 == 0
        }
    }
}
