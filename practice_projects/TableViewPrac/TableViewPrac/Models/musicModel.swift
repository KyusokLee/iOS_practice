//
//  musicModel.swift
//  TableViewPrac
//
//  Created by Kyus'lee on 2022/08/23.
//

import Foundation
// itunes APIを用いてみる
// Spotify apiも可能

struct Music {
    let albumImage: String?
    let singerName: String?
    let songName: String?
    
    init(albumImage: String, singerName: String, songName: String) {
        self.albumImage = albumImage
        self.singerName = singerName
        self.songName = songName
    }
}
