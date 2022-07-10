//
//  DetailMovieViewController.swift
//  MovieApp
//
//  Created by Kyus'lee on 2022/06/30.
//

import UIKit
import AVKit
//Audio, Videoは、提供するUIがないため、コードで実装するしかない
// AVKit: AudioやVideoをコードで実装するために、必要なライブラリ

//MARK: Detail View
// Main ViewからのクリックによるMovie Clip Video, Movie title, Movie Description (longer one)を表示する場所
//映像を載せるUIは、libraryにないため、直接コードで実装してみる

class DetailMovieViewController: UIViewController {
    
    // 📚解決方法2
    // 🔥-> 値を受け取るとたんに、画面と連動されたIBOutletの変数にlogicを与えるのでなく、viewDidLoad()でlogicを反映すればいい
    var movieResult: MovieResult?
    
    // 📚解決方法1で用いた方法
//    var movieResult: MovieResult? {
//        //値を受け取って、画面に載せる
//        //つまり、値を入れたときのみ、didSetが実行される
//        didSet {
//            titleLabel.text = movieResult?.trackName
//            descriptionLabel.text = movieResult?.longDescription
//        }
//    }
    
    var player: AVPlayer?
    
    @IBOutlet weak var movieContainer: UIView!
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        }
    }
    @IBOutlet weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.font = UIFont.systemFont(ofSize: 16, weight: .light)
        }
    }
    
    
    //🔥 画面に表示させるよりも、早く実行されるメソッドだから、IBOutletへのlogicを与えてもcrashにならない
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = movieResult?.trackName
        descriptionLabel.text = movieResult?.longDescription
        
        //🔥以下のようなコードを書くとPlayerが正常に再生されるが、playerのサイズがずれる現象が生じた!
        // 🔥その理由: viewDidLoad()は、該当のviewで載せる表示させる要素をメモリに乗せたが、事前に設定しておいたmovieContainerのサイズだけを認知している。つまり、viewDidLoad()は、Xcode上で作業するSimulatorのサイズを基準にメモリに乗せるので、デバイスのサイズの把握はできないメソッドである。
        // そのため、playerの位置がズレる現象が生じたのである
        
//        if let hasURL = movieResult?.previewUrl {
//            makePlayerAndPlay(urlString: hasURL)
//        }
        
        
    }
    
    //実際に使用するデバイスの大きさとか位置の値を持ってくるメソッド
    override func viewDidAppear(_ animated: Bool) {
        if let hasURL = movieResult?.previewUrl {
            makePlayerAndPlay(urlString: hasURL)
        }
        //しかし、playerの比率(上下に余る部分がある)は、完全にフィットしない
        // その理由は、Urlから持ってくる動画自体の比率の問題
    }
    
    func makePlayerAndPlay(urlString: String) {
        // ただのURLだと、Optionalであるため、安全なOptional Unwrappingである　if let Optional Bindingを用いる
        if let hasURL = URL(string: urlString) {
            // 📚playerオブジェクト生成
            self.player = AVPlayer(url: hasURL)
            // AVPlayerLayer: playerの大きさなどのPlayerに関する枠を管理するオブジェクト
            // これをすることで、playerがようやく大きさという特性を与えることができる
            let playerLayer = AVPlayerLayer(player: player)
            
            // AVPlayerLayerは、ViewじゃなくCGLayer型,つまり addSubviewができない
            
            //そのため、layer.addSubplayerを使う
            
            movieContainer.layer.addSublayer(playerLayer)
            
            //📚Layerは、AutoLayoutの概念がない
            //まだ、Layerの大きさの設定をする
            playerLayer.frame = movieContainer.bounds
            
            //playerのデータを受け取ったとき、勝手に再生されないように、初めからpause()状態になるようにする
            self.player?.pause()
            
        }
    }
    
    @IBAction func close(_ sender: Any) {
        //presentでviewを表示したときだけ、dismissが有効である。presentじゃない方法で、viewを表示したなら、dismissが効かない
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func play(_ sender: Any) {
        self.player?.play()
    }
    
    @IBAction func stop(_ sender: Any) {
        self.player?.pause()
    }
    
    
}
