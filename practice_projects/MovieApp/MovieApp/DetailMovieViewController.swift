//
//  DetailMovieViewController.swift
//  MovieApp
//
//  Created by Kyus'lee on 2022/06/30.
//

import UIKit

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
        
        
    }
    

}
