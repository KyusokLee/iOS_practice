//
//  PhotoCell.swift
//  PhotoGalleryApp
//
//  Created by Kyus'lee on 2022/06/28.
//

import UIKit
import PhotosUI

class PhotoCell: UICollectionViewCell {
    
    func loadImage(asset: PHAsset) {
        // imageで変更させて、持ってくる機能
        let imageManager = PHImageManager()
        
        //画質に関して
        // 指定したsizeに必要なpixelが必要なサイズは、scaleをかけて求められる
        let scale = UIScreen.main.scale
        let imageSize = CGSize(width: 150 * scale, height: 150 * scale)
        
        //optionに対する変数を設ける -> 高画質だけをrequestして、読み込みたい!
        let options = PHImageRequestOptions()
        // 高画質だけ
        options.deliveryMode = .highQualityFormat
        // 低画質だけ
        // options.deliveryMode = .fastFormat
        // 低、高画質両方とも表示させる
        // options.deliveryMode = .opportunistic
        
        //refreshボタンを押すと、ほんの少しの間に写真の順が混ざってるようなreload actionを見せる
        //そのため、self.PhotoImageView.image = nilにして、全部なくしてreloadさせる
        self.PhotoImageView.image = nil

        
        // PHImageManagerは、基本的に低画質と高画質を返すようにシステムがある (options: nilの場合)
        // ⁉️もし、無条件的に高画質だけを読み込みたいときは？: optionsで制約を与えればいい
        //ここは、あくまで持ってきたimageに対する設定である
        // ‼️そのため、ここでcontentModeをaspectFillにしても、持ってきた写真がfillサイズとして適用できるのではない
        imageManager.requestImage(for: asset, targetSize: imageSize, contentMode: .aspectFill, options: options) { image, info in
            // infoを用いて条件分岐する方法
//            if (info?[PHImageResultRequestIDKey] as? Bool) == true {
//                //低画質
//                self.PhotoImageView.image = image
//            } else {
//                //高画質
//                self.PhotoImageView.image = image
//            }
            
            
            
            // appendでimageを格納する方法はよくない
            // -> なぜ？: 低画質と高画質のimageを1回のクリックで2個読み込む
//                self.images.append(image)
            // 2回呼び出しても、自分自身のcellに最初に低画質入れて、次に高画質のimageを入れる
            self.PhotoImageView.image = image
            
        }
        
        
    }
    
    
    
    
    
    //Photo Galleryから持ってきた写真を全部入れておくための変数
    @IBOutlet weak var PhotoImageView: UIImageView! {
        didSet {
            PhotoImageView.contentMode = .scaleAspectFill
        }
    }
    
    
}
