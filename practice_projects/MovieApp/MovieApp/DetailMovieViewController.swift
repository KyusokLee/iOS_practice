//
//  DetailMovieViewController.swift
//  MovieApp
//
//  Created by Kyus'lee on 2022/06/30.
//

import UIKit

//MARK: Detail View: Movie Clip Video, Movie title, Movie Description (longer one)
//映像を載せるUIは、libraryにないため、直接コードで実装してみる


class DetailMovieViewController: UIViewController {
    
    var movieResult: MovieResult? {
        //値を受け取って、画面に載せる
        didSet {
            titleLabel.text = movieResult?.trackName
            descriptionLabel.text = movieResult?.longDescription
        }
    }
    
    
    
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
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

}
