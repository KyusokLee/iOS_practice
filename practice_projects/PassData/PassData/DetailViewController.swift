//
//  DetailViewController.swift
//  PassData
//
//  Created by Kyus'lee on 2022/05/04.
//

import UIKit

class DetailViewController: UIViewController {
    
    // 🌱ただの varは、 そのclassが生成される時点で、ただの var や　let は必ず生成される
    var someString = ""
    
    // 🌱❗️　IBOutlet　は、　画面にあるものが画面に表示される準備ができたあと、生成される
    // 画面に載せる準備ができていない状態で、このIBOutlet プロパティはただの nil である
    // presentなどの画面に載せる関数が呼び出されなくては、この IBoutlet propertyは生成されない
    @IBOutlet weak var someLabel: UILabel!
    
    // viewDidLoad() : 画面が表示される準備ができて、メモリに格納される時点
    override func viewDidLoad() {
        super.viewDidLoad()
        someLabel.text = someString
    }
    
    

}
