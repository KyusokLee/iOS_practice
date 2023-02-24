//
//  RoundImageView.swift
//  AnymationTimer
//
//  Created by Kyus'lee on 2023/02/24.
//

import UIKit

final class RoundImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.clipsToBounds = true
        self.layer.cornerRadius = self.bounds.height / 2
    }
}
