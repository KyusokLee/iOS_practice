//
//  SliderViewController.swift
//  Slider_prac
//
//  Created by Kyus'lee on 2022/08/08.
//

import UIKit

class SliderViewController: UIViewController {
//    // systemFontSize: Standard FontSize
//    let fontSize: CGFloat = UIFont.systemFontSize
//    var changedSize: CGFloat = 0
//    var overValue75: Bool = false

    @IBOutlet weak var secondPageLabel: UILabel!
    
    @IBOutlet weak var valueLabel: UILabel!
    
    @IBOutlet weak var slider: UISlider!
    
    
    @IBAction func sliderValueChange(_ sender: UISlider) {
        let currentValue = sender.value
        valueLabel.text = String(Int(currentValue))
        
        var fontColor = UIColor.black

        // curretValueの値によって、textColorが変わる
        if currentValue >= 75 {
            fontColor = .systemBlue
            valueLabel.text = String(Int(currentValue))
            valueLabel.textColor = fontColor
        } else {
            valueLabel.text = String(Int(currentValue))
            valueLabel.textColor = fontColor
        }
        
//        // sliderのcurrentValueの値によって、fontSizeと色が変わるコード
//        if currentValue >= 75 {
//            if !overValue75 {
//                overValue75 = true
//            }
//            fontColor = .systemBlue
//
//            if changedSize < 50 {
//                changedSize += 2
//                valueLabel.font = UIFont.systemFont(ofSize: fontSize + changedSize)
//            }
//            valueLabel.text = String(Int(currentValue))
//            valueLabel.textColor = fontColor
//        } else {
//            if changedSize <= 0 {
//                valueLabel.text = String(Int(currentValue))
//                valueLabel.font = UIFont.systemFont(ofSize: fontSize)
//                valueLabel.textColor = fontColor
//            } else if changedSize > 0 && overValue75 {
//                changedSize -= 2
//                valueLabel.text = String(Int(currentValue))
//                valueLabel.font = UIFont.systemFont(ofSize: fontSize + changedSize)
//                valueLabel.textColor = fontColor
//            }
//        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        slider.minimumValue = 0
        slider.maximumValue = 100
        slider.value = 50
        valueLabel.text = "\(Int(slider.value))"
    }

}
