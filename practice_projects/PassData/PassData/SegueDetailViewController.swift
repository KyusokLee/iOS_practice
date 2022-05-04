//
//  SegueDetailViewController.swift
//  PassData
//
//  Created by Kyus'lee on 2022/05/04.
//

import UIKit

class SegueDetailViewController: UIViewController {

    @IBOutlet weak var dataLabel: UILabel!
    
    var dataString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataLabel.text = dataString
    }
    
    

}
