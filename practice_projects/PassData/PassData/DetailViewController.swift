//
//  DetailViewController.swift
//  PassData
//
//  Created by Kyus'lee on 2022/05/04.
//

import UIKit

class DetailViewController: UIViewController {
    
    // ð±ãã ã® varã¯ã ãã®classãçæãããæç¹ã§ããã ã® var ããlet ã¯å¿ãçæããã
    var someString = ""
    
    // ð±âï¸ãIBOutletãã¯ããç»é¢ã«ãããã®ãç»é¢ã«è¡¨ç¤ºãããæºåãã§ãããã¨ãçæããã
    // ç»é¢ã«è¼ããæºåãã§ãã¦ããªãç¶æã§ããã®IBOutlet ãã­ããã£ã¯ãã ã® nil ã§ãã
    // presentãªã©ã®ç»é¢ã«è¼ããé¢æ°ãå¼ã³åºãããªãã¦ã¯ããã® IBoutlet propertyã¯çæãããªã
    @IBOutlet weak var someLabel: UILabel!
    
    // viewDidLoad() : ç»é¢ãè¡¨ç¤ºãããæºåãã§ãã¦ãã¡ã¢ãªã«æ ¼ç´ãããæç¹
    override func viewDidLoad() {
        super.viewDidLoad()
        someLabel.text = someString

        
    }
    
    

}
