//
//  ProfileCell.swift
//  Setting_Clone_App
//
//  Created by Kyus'lee on 2022/06/15.
//

import UIKit

class ProfileCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
   
    @IBOutlet weak var topTitle: UILabel!
    
    @IBOutlet weak var bottomDescription: UILabel!
    //cellでは、awakeFromNib()がstartポイントになる
    //viewDidLoad()と似たような役
    //cornerRadius: 角を丸くする (heightの1/2にすると丸になる)
    override func awakeFromNib() {
        super.awakeFromNib()
        let profileHeight: CGFloat = 60
        profileImageView.layer.cornerRadius = profileHeight / 2
        topTitle.textColor = .blue
        topTitle.font = UIFont.systemFont(ofSize: 20)
        
        bottomDescription.textColor = .darkGray
        bottomDescription.font = UIFont.systemFont(ofSize: 16)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
