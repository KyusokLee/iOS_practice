//
//  NetworkLayer.swift
//  MovieApp
//
//  Created by Kyus'lee on 2022/07/11.
//

import Foundation

// MARK: Refactoring -> Clean Codeのための、効率的なチーム協業のために　データを分類する
// 🔥Network へのRequestをするときに、mainVCで全てを行うと、コードが長くなることもあり、目にすぐ入らない問題が生じる。
// -> そのため、Networkに関するlayerを別途で作る
enum MovieAPIType {
    case justURL(urlString: String)
    case searchMovie(querys: [URLQueryItem])
    // 状況によって、必要なものを追加して作ることができる
//    case searchMusic
}

//🔥Error Handling
// Error Typeを作ることができる
// Error　プロトコルを遵守しないといけない
// このようなError処理をすることで、どのような問題で失敗が起きたのかに関して分かる処理が可能
enum MovieAPIError: Error {
    case badURL
}

class NetworkLayer {
    //どのようなものをまとめて、一つのlogicにすることができるかを理解する
    // RequestのType 2つ
    // only URL
    // URL + Parameter
    // closureは、基本的に Underbarを入れるのが規則 -> completion定義したとき、基本型としてUnderbarを入れないといけない
    // 理由: -> Closure は、argument labelを持つことができない
    
    // typealiasを用いて、typeの別称を定義する
    typealias NetworkCompletion = (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void
    
    //@escaping: パラメータTypeの前に記述
    func request(type: MovieAPIType, completion: @escaping NetworkCompletion) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        
        do {
            // 🔥間数にthrowsのキーワードがあった場合、tryのキーワードが必要である
            // ⚠️try というキーワードは、代表的にdo catch文という構造内で使わなければならない (tryの扱いは複数の方法がある)
            // ここで、間数の処理が　throwsに落ちて、失敗になったら、catch文の処理を行う
            // 様々な状況でErrorが考えられるとき、そのErrorに対応するためにtryを使う
            let request = try buildRequest(type: type)
            // ここのfuncに、switch文を用いてTypeごとに分類するコードを作成すると、コードが長くなり、内容がすぐ目に入らない問題が生じる可能性がある
            // そのため、別途のfuncを用いる！
            // networkを通して生成されているあるlogicによって、data, response, errorが生成される
            URLSession.shared.dataTask(with: request) { data, response, error in
                print((response as! HTTPURLResponse).statusCode)
                
                completion(data, response, error)
                
                
            }.resume()
            // 実行終了させる
            session.finishTasksAndInvalidate()
            
        } catch {
            // ここでのerror: 間数の処理でthrowした各errorを意味する
            print(error)
        }
  
    }
    
    // 🔥関数を命名するとき、throws　キーワードを　returnの前に入れることで、throwに当てはまる状況、すなわち、正しくURLRequest Typeをreturn できないときの処理を可能とさせる
    // Returnに失敗したら、Returnまで至らず throwsの処理で終わる!ということ
    // もう一つの新たなReturnを作る！という意味で捉えるといい！
    // 🔥⚠️ 外部で使うことがないなら、private宣言をして、コード作成するときのmissを減らす
    private func buildRequest(type: MovieAPIType) throws -> URLRequest {
        
        switch type {
        case .justURL(urlString: let urlString):
            //Parameterがなく、ただのURLだけでrequestを行う場合
            guard let hasURL = URL(string: urlString) else {
                //正しくURLにアクセスできないとき、上記のenumで作っといたerror typeをthrowするような処理が可能
                throw MovieAPIError.badURL
            }
            
            var request = URLRequest(url: hasURL)
            request.httpMethod = "GET"
            return request
            
        case .searchMovie(querys: let querys):
            var components = URLComponents(string: "https://itunes.apple.com/search")
            components?.queryItems = querys
            guard let hasURL = components?.url else {
                throw MovieAPIError.badURL
            }
            
            var request = URLRequest(url: hasURL)
            request.httpMethod = "GET"
            return request
        }
        
    }
}

