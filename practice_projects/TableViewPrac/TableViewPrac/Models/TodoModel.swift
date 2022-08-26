//
//  TodoModel.swift
//  TableViewPrac
//
//  Created by Kyus'lee on 2022/08/26.
//

import Foundation
// Coredataを用いて、todoをupdate、表示する

struct Todo {
    let title: String
    let detail: String
    
    init(title: String, detail: String) {
        self.title = title
        self.detail = detail
    }
}

var todos = [
    Todo(title: "", detail: "")
]
