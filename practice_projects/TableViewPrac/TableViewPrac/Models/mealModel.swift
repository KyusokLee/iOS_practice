//
//  mealModel.swift
//  TableViewPrac
//
//  Created by Kyus'lee on 2022/08/23.
//

import Foundation

struct Meal {
    let mealType: String
    let mealImage: String
    
    init(mealType: String, mealImage: String) {
        self.mealType = mealType
        self.mealImage = mealImage
    }
}

let mealModels = [
    Meal(
        mealType: "Vegetables",
        mealImage: "meal1"
    ),
    Meal(
        mealType: "Meats",
        mealImage: "meal2"
    ),
    Meal(
        mealType: "Pasta",
        mealImage: "meal3"
    ),
    Meal(
        mealType: "Korean Food",
        mealImage: "kfood.jpeg"
    ),
    Meal(
        mealType: "Japanese Food",
        mealImage: "jfood.jpeg"
    )
]

// jpeg ファイルは、拡張子も一緒に書くこと
