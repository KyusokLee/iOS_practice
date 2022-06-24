//
//  DraggableView.swift
//  PanGestureApp
//
//  Created by Kyus'lee on 2022/06/23.
//

import UIKit

class DraggableView: UIView {
    var dragType = DragType.none
    // CGRect: viewの位置と大きさを示す構造体
    //gestureの設定をする
    // frameのsize値: 現在のviewが占める領域を包み込んで、作った四角形 (superviewの座標系を基準にする) -> superviewの原点は一番左上が(0, 0)である
    // 原点からどれほど離れているのかがframeのx,y座標の値
    // bounds: 自分の原点を (0, 0)におく (自分自身の座標系を基準にする)
    
    
    // このDraggableViewが 最初に作られるとき、必ず以下のinit()logicが実行される
    init() {
        //親のinitを必ずcallする
        //objectは普通、frameを設定する親クラスのinitをcallするのが基本である。
        super.init(frame: CGRect.zero)
        
        //Pan gestureの設定 (Dragのgestureを用いて、画面に変化を与えたいとき使う (UIPanGestureRecognizer))
        let pan = UIPanGestureRecognizer(target: self, action: #selector(dragging))
        //つくるだけだと、viewにはなにも変化が生じない
        //そのため、自分自身のviewにgestureをrecoginizeできるように登録するコードが必要である
        self.addGestureRecognizer(pan)
    }
    
    //UIKitのほとんどは、必ず必要なinit（）がある場合がある
    
    //NSCoderをパラメータとして受け取るinit: コードで作成したobjectじゃなく、interfaceから( + ボタンを押して追加したやつ)生成されたものを扱う
    
    // xibファイルやStoryboardで作成されるときは、init(coder: NSCoder)を通して、生成される
    
    //⁉️なんで、下記のようなコードが必要なのか？: 新しいInterfaceを作るとき、そのinterfaceが必要に応じてここで作ったview クラスを継承するinterfaceにさせたい場合が時々ある。その場合を想定して、required init?(coder: NSCoder)が必要
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        let pan = UIPanGestureRecognizer(target: self, action: #selector(dragging))
        //つくるだけだと、viewにはなにも変化が生じない
        //そのため、自分自身のviewにgestureをrecoginizeできるように登録するコードが必要である
        self.addGestureRecognizer(pan)
//        fatalError("init(coder:) has not been implemented")
    }
    
    //指でクリックしてdragするときに実行されるfunction
    @objc func dragging(pan: UIPanGestureRecognizer) {
        // stateメソッド: 指で押した瞬間の状態を意味する
        switch pan.state {
        case .began:
            //start状態
            print("Began")
        case .changed:
            //changed: 押して動かすときのメソッド
            //translation: objectの変化値を知らせるメソッド
            //in: inパラメータはどのviewを基準にその変換値を適用したいかを意味
            // ここでは、このUIViewの後ろはsuperViewなので、親viewを入れる
            // つまり、動いた距離(x, y軸)に関する値である
            let delta = pan.translation(in: self.superview)
            // 真ん中がこのviewの基準点であることを指す
            var myPosition = self.center
            //objectの絶対座標が必要である
            // deltaが (x軸 + 10) になったら、指定したobjectのpositionもx軸に + 10になるように
            
            // 軸の動きに制約を与える分岐
            if dragType == .x {
                myPosition.x += delta.x
            } else if dragType == .y {
                myPosition.y += delta.y
            } else {
                myPosition.x += delta.x
                myPosition.y += delta.y
            }
            
        
            
            //このままだと、動かしたとき、直ちにself.centerの方に反映されるが、translationの変動地は初期化されず、記録されている
            self.center = myPosition
            //translationの初期化が必要 -> 理由: 動かした分をcenterに全部渡してしまったから
            //setTranslation: panGesture値の初期化
            //CGPoint.zero -> point値を初期化する
            //つまり、新しい動きが入る前に、初期化させ、また次の動きから生じる変動地を上手く設定するため
            pan.setTranslation(CGPoint.zero, in: self.superview)
        
        case .ended, .cancelled:
            //一緒に処理したい場合は、,(comma)で括ることが可能
            print("Ended")
            //画面の外に行くことに制約を与える
            // minX: 左上の点(Rectangleの)
            // minXは、あくまでloadするときだけ使える
            // Settingは、origin.x
            
            //左の方に画面の外に出るのを制限させる
            if self.frame.minX < 0 {
                self.frame.origin.x = 0 //左部分 0
            }
            
            //右の方の画面の外に出るのを制限させる
            // superviewがあるかもしれないし、ないかもしれないから if let でoptional unwrappingを行う
            if let hasSuperView = self.superview {
                if self.frame.maxX > hasSuperView.frame.maxX {
                    // origin.x は、左上の方の点を指す
                    self.frame.origin.x = hasSuperView.frame.maxX - self.bounds.width
                }
            }
            
        default:
            break
        }
    }
    
}


//        case .ended:
//            //押して上手く動かされてそのgestureが終わったとき
//
//        case .cancelled:
//            //なにかのobjectを押している状態でviewの遠くのとこに置くと、cancellされる
//
