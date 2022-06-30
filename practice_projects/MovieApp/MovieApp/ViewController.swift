//
//  ViewController.swift
//  MovieApp
//
//  Created by Kyus'lee on 2022/06/29.
//

import UIKit

//MARK: 📝知識復習
//delegate: 普段、Eventを連動させるfuncが存在する
//dataSource: 普段、Dataを連動させるfuncが存在する (cellの形式の調整なども含む)

//MARK: Movie Appを作った理由: API, Json Parsingを通して、networkの基本とios　アプリへの連動方法を学ぶ
// 講義やgoogle検索をしながら、完成した

//📮MARK: AutoLayoutに関する理解
// 🔥AutoLayoutを使う時、content hugging priorityが同じだと、それぞれのUIへのlayout設定において競合が発生してしまい、systemが判断できなくなる
// ⬆️そのため、priority を調整するのである。
// 例えば、UI1とUI2あるとし、UI2をUI1のサイズよりvertical（縦）に広く表示させたいとき、UI1のpriorityをUI1のPriorityより大きくすると、UI1のlayoutを優先的に設定し、次にUI2のlayoutを設定する。
// -> UI1のサイズを設定した値通りに、しっかりと表示させたいとき、そのUIのpriorityを最も高うすればいい
//すなわち、他のUIの方がpriorityが高いため、最も低いpriorityを持つUIは自分自身のサイズを保つことができなくなり、他のUIよりサイズ(layout)が引っ張られる

//📮MARK: URL Get Requestに関して
// Postmanを使って、https get requestをしてみた (itunes API 利用)
// headerの値を見てみると、content-disposition がある
// content-dispositionに、attachment; filename = 1.txtと書いてある
// これは、browserを用いてget requestをしたとき、画面を見せてくれるのではなく、fileとしてユーザに提供するということ (file名: 1.txt)

// URL Requestをするとき、必要なもの
// 1. Json parsingを行うmodel
// 2. Network Accessに関するlogic構成

class ViewController: UIViewController {
    // 最初に生成をして、値が入力されるべきだから、単に値を生成できるわけではない
    // そのため、Optional wrappingをした
    var movieModel: MovieModel?

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var movieTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieTableView.delegate = self
        movieTableView.dataSource = self
        searchBar.delegate = self
        
        requestMovieAPI()
        
    }
    
    //URLアドレスを用いて、imageを持ってくるfuncを生成
    // funcの中のclosureをreturnとして返したい場合: closure typeをparameterで設ける
    // ここでは、UIImageを渡したいから、(UIImage) -> Voidに設定
    
    func loadImage(urlString: String, completion: @escaping (UIImage?) -> Void ) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        
        // URL(): url型に変換する
        if let hasURL = URL(string: urlString) {
            var request = URLRequest(url: hasURL)
            request.httpMethod = "GET"
            
            // networkを通して生成されているあるlogicによって、data, response, errorが生成される
            session.dataTask(with: request) { data, response, error in
                print((response as! HTTPURLResponse).statusCode)
                //dataをimageに変換する
                if let hasData = data {
                    //⚠️このままだと、errorになる
                    // なぜ？: 正常にimageへの変換ができるかどうかは試してみないとわからないので、Optionalになっている
                    // そのため、funcのparameterに UIImage?にしておく
                    completion(UIImage(data: hasData))
                    return
                    //‼️closure中で提供する値(data, response, errorのようなもの)は、closureを抜け出す瞬間、値が消えるlife cycleになっている
                    // 🔥そのため、escapingする必要がある
                    // funcのparameterで　escapingをしておくこと
                }
                // closureの中でreturnしても、funcのreturnに反映されない
                // ->理由: threadが異なる ->そのため、closure をparameterにするなどの工夫が必要
            }.resume()
        }
        
        
        // ‼️funcのparameterので定めたclosureは、呼び出されなかったら、このfuncはずっとメモリのどこかを占めることになる
        // そのため、urlへの変換やimageへの変換(上記で記入したコード)で失敗したとき(if let の中を通さずにここにくるとき)に備えて、completionに(nil)を格納したまま返す作業をする
        completion(nil)
    }
    
    
    
    // ⭐️network 呼び出し    重要度: Very Important🔥
    // Open Source を使わずにした方法
    // cocoapod , alamofireなど
    func requestMovieAPI() {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        
        // 基本的に使おうとするURLのDomain
        // Optional 値
        var components = URLComponents(string: "https://itunes.apple.com/search")
        
        //Query Stringを使って、target要素を指定
        let term = URLQueryItem(name: "term", value: "marvel")
        let media = URLQueryItem(name: "media", value: "movie")
        
        // queryItemsは、配列型である [URLQueryItem]
        components?.queryItems = [term, media]
        
        guard let url = components?.url else {
            return
        }
        
        var request = URLRequest(url: url)
        // Readをする場合: httpMethod: "GET"
        // Read, Writeをする場合: httpMethod: "POST"
        // POSTもread可能
        request.httpMethod = "GET"
        
        //dataTask: data, response, errorをhandlingするclosure
        // data, response, error　全部optional値である
        let task = session.dataTask(with: request) { data, response, error in
            // statusCode: 開発者が必ず知っておくべき httpの状態code
            // 2xx: 成功に関するstatus
            // 3xx: redirection: pageが他のところにアクセスして可能とすること
            // 4xx: requestのerror
            // 5xx: server自体に問題があるとき, networkに問題があるとき
            
            // 200: 成功
            
            // ここでは、強制typeCastingをしたが、Optional Unwrappingの方がおすすめ
            print((response as! HTTPURLResponse).statusCode)
            
            //ここで、作ったととしても、自動的にアプリに更新されるわけではない
            // -> delegate, datasourceの方で処理のlogicを実装する必要がある
            
            //⁉️自動に更新させるのは、Bindingになっているとき
            // Bindingをするという概念は、Rx style (RxSwift)
            // modelに変化があるとき、自動に更新される
            // ここでは、根本となるprogramming codeで再現した
            
            if let hasData = data {
                //Decoding: 人がわかるような表記にする処理
                // すなわち、扱う言語として変換させる処理ということ
                // decode(どんなtypeにdecodingするの？, どんなdataをdecodingしたいの？)
                // decodeは　throwになっているメソッドである
                // そのため、do (try) catch 文を用いてerror処理をしないといけない
                do {
                    self.movieModel = try JSONDecoder().decode(MovieModel.self, from: hasData)
                    print(self.movieModel ?? "No Data")
                    //JSON Parsingをして、正しくデータを持ってくることができたら、ここで次の処理が行われる
                    
//                    // movieTableViewを改めて読み込んでね！
//                    self.movieTableView.reloadData()
                    //‼️しかし、このままだと、errorになってしまう
                    // 🔥‼️画面のUIの変化に関わる全てのものは、main threadでやらなきゃいけない！
                    // closureの中で書いたコードは、main threadではないため、直接dispatchQueue.mainがやるよう！というコードを書く必要がある
                    
                    DispatchQueue.main.async {
                        self.movieTableView.reloadData()
                    }
                    
                } catch {
                    // catchの方にerrorの時の処理をthrowするね！
                    // tryを試したときの失敗したケースをここで、知らせる
                    print(error)
                }
                
            }
            
            
            
        }
        
        // dataTask.resume() : 実際に実行する
        task.resume()
        // 実行終了させる
        session.finishTasksAndInvalidate()
        
    }


}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    //❗️最新のiosでは、cellの高さを指定しなくても、contentsのサイズに合わせ、自動的にsizeが決まって、正しく表示される
    //MARK: 昔のiosでは、下記のfuncを使ってcellの高さを調整する必要があった
    // 昔のiosも対応させるため、もしくは、社内で決まっているDesign Guideがあるときは、cellのheightを決めるのが拡張性の面で正しいと思われる
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        
////        // cellの高さをそれぞれ150にしておく場合
////        return 150
//        // contentsのサイズに合わせて、sizeを表示させたい場合
//        return UITableView.automaticDimension
//    }
    
    //ここで決めたなら、上のfuncは要らない
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    //数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movieModel?.results.count ?? 0
    }
    
    //cellの形式を決定する
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // indexPath: 位置に関する順番の概念
        //　強制Type Castingした理由: Optional Castingを用いて nilのときのError handlingもできるが、ここのlogicはミスをしてはいけない場合なので、強制castingにした方がいいと思った
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        cell.titleLabel.text = self.movieModel?.results[indexPath.row].trackName
        cell.descriptionLabel.text = self.movieModel?.results[indexPath.row].shortDescription
        
        let currency = self.movieModel?.results[indexPath.row].currency ?? ""
        
        //他のtypeの変数は、descriptionを通して、String型に変換してくれる
        let price = self.movieModel?.results[indexPath.row].trackPrice.description ?? ""
        
       
        cell.priceLabel.text = currency + price
        // + などの演算子はoptionalは対応しない
        // trackPriceはint型だったため、正しくdecoding できなかった
        // print(error)が実行される
        
        // 🖍itunes APIを用いた場合に限る話
        //🔥imageは、jsondecodeから得られたhttpアドレスに再び入って処理する作業があるため、他のstring型とは違い、別途の追加作業が必要
        // つまり、imageが入っている経路を提供していることが分かる
        // 値がない時を備えたoptional chainingであるため、if letでoptional unwrappingを再びしておく
        if let hasImageURL = self.movieModel?.results[indexPath.row].image {
            self.loadImage(urlString: hasImageURL) { image in
                //UIImageView.imageは　Optionalであるため、ここのclosureで提供するimageがnilの場合、movieImageView.imageがnilにsetされ、imageになにも表示されない。
                // optional Unwrappingがいらないってこと
                
                //imageだけは、loadImage間数を呼び出して、再びURL GET Request作業をしたため、requestMovieAPI()間数でmain threadへの移行が完成されない
                // requestMovieAPI()間数は、あくまで url get request処理を用いて、JSON decodingをし、movieTableViewに持ってくるようにreloadしただけで、imageの場合は、その段階ではimage として正しく変換されないのである。
                // そのため、loadImage()呼び出す部分で、追加的に DispatchQueue.main.async　コードを作成し、main threadへの移行処理をする必要がある
                DispatchQueue.main.async {
                    cell.movieImageView.image = image
                }
            }
        }
        
        return cell
    }
    
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    
}


