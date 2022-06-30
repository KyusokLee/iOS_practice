//
//  MovieModel.swift
//  MovieApp
//
//  Created by Kyus'lee on 2022/06/30.
//

import Foundation
// API Json Parsingを行うための、modelの作成
// Codable: encoding, decoding両方とも提供する protocol
// 必要だと思ってるものだけ、struct内で設けること
// Keyを書かないと、そのkeyのvalueを使えない


struct MovieModel: Codable {
    let resultCount: Int
//    let results: [XXXXX] 配列model
    // ここで、作ると少し見にくいので、新しいmodelを作成した
    let results: [Result]
    
}

struct Result: Codable {
    let trackName: String
    let previewUrl: String
    let image: String
    let shortDescription: String?
    let longDescription: String
    let trackPrice: Double
    let currency: String
    
    // URL Requestから得られたkeyをそのまま使うのではなく、変更して使いたい!
    // その場合は、CodingKeyを使って、名前を変更できる
    // しかし、使いたいkeyを全部書く必要がある
    enum CodingKeys: String, CodingKey {
        case image = "artworkUrl100"
        case trackName
        case previewUrl
        case shortDescription
        case longDescription
        case trackPrice
        case currency
    }
}
