//
//  AnimationTestButton.swift
//  TableViewPrac
//
//  Created by Kyus'lee on 2022/09/11.
//

import UIKit

// Button Clickすると、LaunchVCで Animationが再生されるViewをpresentするように

class AnimationTestButton: UIButton {
    
    init() {
        super.init(frame: CGRect.zero)
        configure()
    }
    
    // Storyboard または、nibファイルで設定したとき
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.backgroundColor = .systemTeal.withAlphaComponent(0.8)
        self.tintColor = .white
    }
    
    func resizingImage(width: CGFloat, height: CGFloat) -> UIImage? {
        let customImage = UIImage(systemName: "plus.circle")
        let newImageRect = CGRect(x: 0, y: 0, width: width, height: height)
        // New Draw
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        customImage?.draw(in: newImageRect)
        // alwaysTemplateにすると、tintColorの変更が可能
        let newImage = UIGraphicsGetImageFromCurrentImageContext()?.withRenderingMode(.alwaysTemplate)
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
}
