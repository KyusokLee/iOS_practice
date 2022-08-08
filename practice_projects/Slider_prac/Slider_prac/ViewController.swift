//
//  ViewController.swift
//  Slider_prac
//
//  Created by Kyus'lee on 2022/08/08.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func moveToSliderVC(_ sender: Any) {
        let sliderVC = SliderViewController(nibName: "SliderViewController", bundle: nil)
        // ⚠️Error: 画面が表示されていないのに、IBOutlet変数に直接入れようとしている
        // 🌈Solution: Presentの後に書けばいい
//        sliderVC.secondPageLabel.text = "First Page -> Second Page"
        
        self.present(sliderVC, animated: true, completion: nil)
        // sliderVCのPageLabelにString dataを渡す
        sliderVC.secondPageLabel.text = "First Page -> Second Page"
        // Labelのtextcolor変更
        sliderVC.secondPageLabel.textColor = .purple
        // Labelのfont 種類, fontsize変更
        sliderVC.secondPageLabel.font = UIFont.boldSystemFont(ofSize: 20)
    }
    

}

