//
//  ViewController.swift
//  MovieApp
//
//  Created by Kyus'lee on 2022/06/29.
//

import UIKit

// itunes　API: 1分で20回のAPI Requestしかできないので、testするときは、相応しいと思うが、実際のサービスを作るときに使うのは適切でないと思う


// ‼️追加したい機能: ボタンを用いて国を設定し、英語のデータ、韓国のデータ、日本のデータをそれぞれ受け取り、viewに表示するものも設定した言語通りに受け取るようにしたい

// ⚠️boringssl_metrics_log_metric_block_invoke(153)のエラーがconsoleで表示される
// -> 色々調べてみたが、これはXcodeのバージョンアップに伴うエラーであり、無視しても大丈夫だと言っている人が多数であった。(stackoverflowなど)
// このエラーが常時されていても、アプリは正常に動いている!
// ⚠️途中の段階: 既存の session.dataTask() -> URLSession.shared.dataTaskに変更したら、detailVCに入る前に出たblock_invoke(153)エラーは出なくなったが、detailVCに入ると、また同じエラーが出る -> DI(依存性注入)を使うとより効率的な処理が可能らしい



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

//📮MARK: JSON Decodingから得られたvalueを好きなように変更して使いたい場合

// DateFormatの場合は、ISO8601の規約で定められた formatがある
//


class ViewController: UIViewController {
    // 最初に生成をして、値が入力されるべきだから、単に値を生成できるわけではない
    // そのため、Optional wrappingをした
    var movieModel: MovieModel?
    var term = ""
    var networkLayer = NetworkLayer()

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var movieTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieTableView.delegate = self
        movieTableView.dataSource = self
        movieTableView.keyboardDismissMode = .onDrag
        searchBar.delegate = self
        
        requestMovieAPI()
    }
    
    //MARK: DataModelを分離した方法
    func loadImage(urlString: String, completion: @escaping (UIImage?) -> Void ) {
        networkLayer.request(type: .justURL(urlString: urlString)) { data, response, error in
            
            if let hasData = data {
                completion(UIImage(data: hasData))
                return
                //‼️closure中で提供する値(data, response, errorのようなもの)は、closureを抜け出す瞬間、値が消えるlife cycleになっている
                // 🔥そのため、escapingする必要がある
                // funcのparameterで　escapingをしておくこと
            }
            completion(nil)
        }
    }
    
    // MARK: DataModelを分類しない方法
//    //URLアドレスを用いて、imageを持ってくるfuncを生成
//    // funcの中のclosureをreturnとして返したい場合: closure typeをparameterで設ける
//    // ここでは、UIImageを渡したいから、(UIImage) -> Voidに設定
//
//    func loadImage(urlString: String, completion: @escaping (UIImage?) -> Void ) {
//        let sessionConfig = URLSessionConfiguration.default
//        let session = URLSession(configuration: sessionConfig)
//
//        // URL(): url型に変換する
//        if let hasURL = URL(string: urlString) {
//            var request = URLRequest(url: hasURL)
//            request.httpMethod = "GET"
//
//            // networkを通して生成されているあるlogicによって、data, response, errorが生成される
//            session.dataTask(with: request) { data, response, error in
//                print((response as! HTTPURLResponse).statusCode)
//                //dataをimageに変換する
//                if let hasData = data {
//                    //⚠️このままだと、errorになる
//                    // なぜ？: 正常にimageへの変換ができるかどうかは試してみないとわからないので、Optionalになっている
//                    // そのため、funcのparameterに UIImage?にしておく
//                    completion(UIImage(data: hasData))
//                    return
//                    //‼️closure中で提供する値(data, response, errorのようなもの)は、closureを抜け出す瞬間、値が消えるlife cycleになっている
//                    // 🔥そのため、escapingする必要がある
//                    // funcのparameterで　escapingをしておくこと
//                }
//                // closureの中でreturnしても、funcのreturnに反映されない
//                // ->理由: threadが異なる ->そのため、closure をparameterにするなどの工夫が必要
//            }.resume()
//            // ❗️delegateやCallbackオブジェクトへの参照をクリアしないとメモリーリークを起こす
//            // そのため、finishTasksAndInvalidate()を使う
//            // メモリーリークとは、プログラムが必要としないメモリを占有して続けている現象
//            session.finishTasksAndInvalidate()
//        }
//
//
//        // ‼️funcのparameterので定めたclosureは、呼び出されなかったら、このfuncはずっとメモリのどこかを占めることになる
//        // そのため、urlへの変換やimageへの変換(上記で記入したコード)で失敗したとき(if let の中を通さずにここにくるとき)に備えて、completionに(nil)を格納したまま返す作業をする
//        completion(nil)
//    }
    
    //MARK: DataModelを分離した方法
    func requestMovieAPI() {
        //Query Stringを使って、target要素を指定
        let term = URLQueryItem(name: "term", value: term)
        let media = URLQueryItem(name: "media", value: "movie")
        let querys = [term, media]
        
        networkLayer.request(type: .searchMovie(querys: querys)) { data, response, error in
            
            if let hasData = data {
                
                do {
                    self.movieModel = try JSONDecoder().decode(MovieModel.self, from: hasData)
                    
                    DispatchQueue.main.async {
                        self.movieTableView.reloadData()
                    }
                    
                } catch {
                    print(error)
                }
            }
        }
    }
    
    
    // MARK: DataModelを分類しない方法
//    // ⭐️network 呼び出し    重要度: Very Important🔥
//    // Open Source を使わずにした方法
//    // cocoapod , alamofireなど
//    func requestMovieAPI() {
//        let sessionConfig = URLSessionConfiguration.default
//        let session = URLSession(configuration: sessionConfig)
//
//        // 基本的に使おうとするURLのDomain
//        // Optional 値
//        var components = URLComponents(string: "https://itunes.apple.com/search")
//
//        //Query Stringを使って、target要素を指定
//        let term = URLQueryItem(name: "term", value: term)
//        let media = URLQueryItem(name: "media", value: "movie")
////        // 読み込むデータの国の設定
////        let country = URLQueryItem(name: "country", value: "JP")
////        // 表示させる言語の設定
////        let language = URLQueryItem(name: "lang", value: "ja_jp")
//
//        // queryItemsは、配列型である [URLQueryItem]
//        components?.queryItems = [term, media]
//
//        guard let url = components?.url else {
//            return
//        }
//
//        var request = URLRequest(url: url)
//        // Readをする場合: httpMethod: "GET"
//        // Read, Writeをする場合: httpMethod: "POST"
//        // POSTもread可能
//        request.httpMethod = "GET"
//
//        //dataTask: data, response, errorをhandlingするclosure
//        // data, response, error　全部optional値である
//        let task = session.dataTask(with: request) { data, response, error in
//            // statusCode: 開発者が必ず知っておくべき httpの状態code
//            // 2xx: 成功に関するstatus
//            // 3xx: redirection: pageが他のところにアクセスして可能とすること
//            // 4xx: requestのerror
//            // 5xx: server自体に問題があるとき, networkに問題があるとき
//
//            // 200: 成功
//
//            // ここでは、強制typeCastingをしたが、Optional Unwrappingの方がおすすめ
//            print((response as! HTTPURLResponse).statusCode)
//            // ⚠️response: iron manm harry porter でない
//
//            //ここで、作ったととしても、自動的にアプリに更新されるわけではない
//            // -> delegate, datasourceの方で処理のlogicを実装する必要がある
//
//            //⁉️自動に更新させるのは、Bindingになっているとき
//            // Bindingをするという概念は、Rx style (RxSwift)
//            // modelに変化があるとき、自動に更新される
//            // ここでは、根本となるprogramming codeで再現した
//
//            if let hasData = data {
//                //Decoding: 人がわかるような表記にする処理
//                // すなわち、扱う言語として変換させる処理ということ
//                // decode(どんなtypeにdecodingするの？, どんなdataをdecodingしたいの？)
//                // decodeは　throwになっているメソッドである
//                // そのため、do (try) catch 文を用いてerror処理をしないといけない
//                do {
//                    self.movieModel = try JSONDecoder().decode(MovieModel.self, from: hasData)
//                    print(self.movieModel ?? "No Data")
//                    //JSON Parsingをして、正しくデータを持ってくることができたら、ここで次の処理が行われる
//
////                    // movieTableViewを改めて読み込んでね！
////                    self.movieTableView.reloadData()
//                    //‼️しかし、このままだと、errorになってしまう
//                    // 🔥‼️画面のUIの変化に関わる全てのものは、main threadでやらなきゃいけない！
//                    // closureの中で書いたコードは、main threadではないため、直接dispatchQueue.mainがやるよう！というコードを書く必要がある
//
//                    DispatchQueue.main.async {
//                        self.movieTableView.reloadData()
//                    }
//
//                } catch {
//                    // catchの方にerrorの時の処理をthrowするね！
//                    // tryを試したときの失敗したケースをここで、知らせる
//                    print(error)
//                }
//
//            }
//
//
//
//        }
//
//        // dataTask.resume() : 実際に実行する
//        task.resume()
//        // 実行終了させる
//        session.finishTasksAndInvalidate()
//
//    }
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
    
    //クリック(select)に関するfunc
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        //ここまでは、storyboardのファイルにアクセスした状態
//        let detailVC = UIStoryboard(name: "DetailMovieViewController", bundle: nil)
        // storyboardファイルにアクセスし、そこにあるviewControllerにアクセスしなきゃいけない
        let detailVC = UIStoryboard(name: "DetailMovieViewController", bundle: nil).instantiateViewController(withIdentifier: "DetailMovieViewController") as! DetailMovieViewController
        
        //選択したrowが、ずっとgray色で表示されるのを防ぐ
        // つまり、クリックしたとたんに、クリックが解除されるanimation効果を与える
        tableView.deselectRow(at: indexPath, animated: true)
        
        detailVC.movieResult = self.movieModel?.results[indexPath.row]
//        //🌱FullScreenでviewをpresentしたいとき
//        //　FullScreenでpresentしたときは、dragでviewを下ろすことが不可能である -> 必ず、buttonが必要
//        detailVC.modalPresentationStyle = .fullScreen
        
        self.present(detailVC, animated: true, completion: nil)
        
        // self.presentでcompletionをnilにして、detailVCを開こうとすると、画面と連動されたIBOutletを扱うただの変数 movieResultでcrashになってしまう。
        // 理由: IBOutletの変数の定義が、detailVCのviewDidLoad()メソッドの前に書かれているし、viewDidLoad()の前にmovieResult変数を通してアクセスしようとしたからだ。そうすると、その時点では何も作られていないから、titleLabelとdescriptionlabelはnilである。
        
//        // 📚解決方法1
//        // 🔥-> completionを用いて、追加的なlogicを書く必要がある
//        // この方法を用いると、ほんの少しの間に detailVCで受け取ったデータが正しく反映されないviewが見える
//
//        self.present(detailVC, animated: true) {
//            //画面が開かれたら追加的に処理したいlogic
//            detailVC.movieResult = self.movieModel?.results[indexPath.row]
//        }
        
        
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
        let price = self.movieModel?.results[indexPath.row].trackPrice?.description ?? ""
        
       
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
        
        // Optional Unwrapping
        if let dateString = self.movieModel?.results[indexPath.row].releaseDate {
            // formatterの指定: dateをいじりたいときは、ISO8601DateFormatter()
            let formatter = ISO8601DateFormatter()
            // formatterから何年, 何月, 何日, 秒単位までの時刻 dateを読み込み、そのデータを持ってくるメソッド
            if let isoDate = formatter.date(from: dateString) {
                //📮MARK: 好きなフォーマットに変えたい場合 (🎖日付に関しての場合🎖)
                //1. custom Formatの指定: DateFormatter()の変数作成
                //2. 指定したformatterにあるメソッドを使う
                // .dateFormat: 日付を好きなスタイルにcustomize
                // ❗️ただし、yyyy: 年度, MM: 月, dd: 日は決まっている
                let myFormatter = DateFormatter()
                myFormatter.dateFormat = "公開日: yyyy年 MM月 dd日"
                
                // 上記で読み込んだデータごとのisoDateを自分が作成したformatに適応させたい
                let myDateString = myFormatter.string(from: isoDate)
                
                cell.dateLabel.text = myDateString
            }
            
        

        }
        
        
        
        return cell
    }
    
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let hasText = searchBar.text else {
            return
        }
        term = hasText
        requestMovieAPI()
        //keyboard　下ろす
        self.view.endEditing(true)
    }
    
    
}


