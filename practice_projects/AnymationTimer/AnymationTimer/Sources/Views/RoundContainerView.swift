//
//  RoundContainerView.swift
//  AnymationTimer
//
//  Created by Kyus'lee on 2023/02/24.
//

import UIKit

final class RoundContainerView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.clipsToBounds = true
        self.layer.cornerRadius = self.bounds.width / 2
    }
}
