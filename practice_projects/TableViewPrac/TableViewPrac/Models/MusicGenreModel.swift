//
//  MusicGenreModel.swift
//  TableViewPrac
//
//  Created by Kyus'lee on 2022/08/24.
//

import Foundation
import UIKit

struct MusicGenre {
    let genre: String
    let description: String
    let backgroundColor: UIColor
    
    init(genre: String, description: String, backgroundColor: UIColor) {
        self.genre = genre
        self.description = description
        self.backgroundColor = backgroundColor
    }
}

// backgroundColor: .init(red: 100, green: 150, blue: 150, alpha: 0.3)のようなものは、outside the expected range warningがでる

let musicGenreModels = [
    MusicGenre(
        genre: "JPOP",
        description: "よく聞くジャンル",
        backgroundColor: .systemBlue
    ),
    MusicGenre(
        genre: "KPOP",
        description: "가끔 듣는 장르",
        backgroundColor: .orange
    ),
    MusicGenre(
        genre: "POP",
        description: "Listen sometimes",
        backgroundColor: .purple
    ),
    MusicGenre(
        genre: "Club Musics",
        description: "元気な時聞く",
        backgroundColor: .black
    )
]
