//
//  ViewController.swift
//  App_Start1
//
//  Created by Kyus'lee on 2022/05/02.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var testButton: UIButton!
    
    @IBAction func doSomething(_ sender: Any) {
        testButton.backgroundColor = .orange
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = storyBoard.instantiateViewController(identifier: "DetailViewController") as DetailViewController
        
        self.present(detailVC, animated: true, completion: nil)
        
        
    }
    //画面に表示する準備ができてるとき実行される
    override func viewDidLoad() {
        super.viewDidLoad()
        testButton.backgroundColor = UIColor.red
    }


}

