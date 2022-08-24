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
    )
]
