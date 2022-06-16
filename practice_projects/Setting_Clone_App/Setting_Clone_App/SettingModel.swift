//
//  SettingModel.swift
//  Setting_Clone_App
//
//  Created by Kyus'lee on 2022/06/17.
//

import Foundation

// modelの構築
// -> profileCellは、description Labelがあり、右押しボタンがない
// -> 一方、MenuCellは、description Labelないし、右押しボタンUIがある
// 上記のような一連のsystemをmodelingしたいから、structを用いてModel化する
struct SettingModel {
    var leftImageName: String = ""
    var menuTitle: String = ""
    //subTitleは指定cellによってあるかもしれないし、ないかもしれない
    //そのため、
    var subTile: String?
    // menuTitleの理由と一緒
    var rightImageName: String?
    
}
