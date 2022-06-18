//
//  ViewController.swift
//  Setting_Clone_App
//
//  Created by Kyus'lee on 2022/06/15.
//

import UIKit

// 🔥AutoLayoutについての考察:
// デバイスのサイズはそれぞれ違うので、AutoLayoutはなるべく、数字を指定するのではなく、比率(multiplier)で調整すること！特に、イメージの位置を調整するとき！
// 真ん中に整列: veremultplier: alligments constraintsの部分で -> vertical, horizonを初期値0にしてクリックする
// イメージの詳細サイズ調整: 調整したいImage Viewをクリックし、viewの詳細設定で 縦軸だったらyのとこで調整
// multiplier(比率): 0 -> 真ん中
//    0.5 -> VCの一番上から真ん中の間の真ん中
//    1.5 -> VCの一番下から真ん中の間の真ん中



// 🔥TableViewを使う時には、protocolを順守するSettingを設ける必要ががある: UITableViewDelegate, UITableViewDataSourceは必ず必要
// extensionを用いてclassのコードが長くなることを防ぐと同時に、読み手(自分を含めて)にとってわかりやすくする
// sectionであることをわかりやすくするために、sectionごとの間隔を入れたい -> tableViewのstyleを plain　から　groupedに変更すればいい

class ViewController: UIViewController {
    // ⁉️Outlet Objectの変数名をrenameするときは、必ず referencing outletsで既存に作成したやつを削除すること!
    // ⁉️NSUnknownKeyExceptionエラーの解決方
    // ❗️Warning once only: Detected a case where constraints ambiguously -> 警告
    // ❗️原因: autoLayoutに対するcellの制約条件(constraints)が十分与えられてないため、table viewにcellのheightを知らせる警告である
    //SettingModel構造体をmodelとする２次元配列を設けて、sectionごとに一つの配列にappendする。
    var settingModel = [[SettingModel]]()
    
    @IBOutlet weak var settingTableView: UITableView!
    
    func makeData() {
        settingModel.append(
        [SettingModel(leftImageName: "person.circle", menuTitle: "Sign in to your iPhone", subTitle: "Set up iCloud, the App Store, and more.", rightImageName: nil)])
        settingModel.append([SettingModel(leftImageName: "gear", menuTitle: "General", subTitle: nil, rightImageName: "chevron.right"),
        SettingModel(leftImageName: "person.fill", menuTitle: "Accessibility", subTitle: nil, rightImageName: "chevron.right"),
        SettingModel(leftImageName: "hand.raised.fill", menuTitle: "Privacy", subTitle: nil, rightImageName: "chevron.right")])
    }
    
    //画面が表示されるたびに呼び出されるメソッド -> swift LifeCycleの一つ
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 画面が表示されるたびに、指定したlargeTitleが表示される
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // クリックしたいcellをクリックしてそのcellの詳細について見たい場合は、viewDidLoad()が消されてまた、生成されるから以下のままのコードでいいが、mainの場合はnavigationControllerが維持されるため、最初に設定しておいた LargeTitleがなくなる
    // そのため、viewWillAppearを使う必要がある
    
    
    // 🎖viewDidLoad()は、メモリが解除されてからまた、メモリに載せる時、その1回だけ実行されるメソッドだから、詳細viewControllerに移動しても、main ViewControllerのメモリが解除されてなく、detail VCの後ろにまだ生きている状態. -> だから、viewDidLoad()がまた実行されるわけではない！❗️
    // 例えば、"General" cellをクリックして、generalViewControllerに移動しても、mainVCメモリはまだなくなっていないため、viewDidLoad()が実行されず、navigationController?.navigationBar.prefersLargeTitles = trueが再び現れない -> viewWillAppearで書くこと!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //以下のコードを書かないと表示されない
        settingTableView.delegate = self
        settingTableView.dataSource = self
//        //tableViewのbackgroundの色を変える -> UIKitを提供するcolorを使った方法
//        settingTableView.backgroundColor = .lightGray
        settingTableView.backgroundColor = UIColor(white: 245/255, alpha: 1)
        // 255/255が1 -> 最もwhiteに近い感じ
        // 少し、黒くしたいから 255からちょっと引いた
        
        
        // 🔥コードでTableViewControllerにTabelCellを登録する方法
        // 必ずcellをtableViewに登録させる -> しないと、crashになる
        settingTableView.register(UINib(nibName: "ProfileCell", bundle: nil), forCellReuseIdentifier: "ProfileCell")
        settingTableView.register(UINib(nibName: "MenuCell", bundle: nil), forCellReuseIdentifier: "MenuCell")
        // ここでは、データが読み込まれて一回表示させるだけなので、titleはtrueになっているのが、他のcellをクリックしてから現在の場面に戻ってくると表示されなくなる
        title = "Settings"
//        navigationController?.navigationBar.prefersLargeTitles = true
        self.view.backgroundColor = UIColor(white: 245/255, alpha: 1)
        
        //selfなくてもあっても別に構わない
        // self自体が指定されたclassのことを指すので、統一性のために、書かないのがより読みやすいかなと
        // ただし、ここではlogicを全部把握したいので、書いておいた
        // メモリにデータが載せられるとき、modelingした modelData()が必要であるため、ここに書く必要がある
        makeData()
    }


}


//以下のextensionの記入の理由: tableViewの実現のため
// tableViewの代理人 (delegate), tableViewのdataSource (dataSource)は、必ず従わないといけないprotocolが存在する
// ❗️tableViewは、データの画面表示だけを管理する。データ自体は管理しない。 データを管理するには、tableにdataSourceオブジェクト、つまりUITableViewDataSourceプロトコルを実装するオブジェクトを指定する必要があるということ！
// 内容がそんなに複雑でなく、かつ、散漫でない場合は、コンマ(,) を使って一緒に定めていい

// cellのheightを決められる-> UITableViewDelegateの中に定義されている
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // ここで、numberOfRowInSectionが指すのは、Cellの数である
        // 下記で書いたindexPathは、ここでsectionと繋げればいい
        // settingModelの一つの配列に入れたcellの数
        // ex) ProfileCell: 1, MenuCell: 3
        // つまり、sectionごとのcountを出力する
        return settingModel[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // sectionの個数
        return settingModel.count
    }
    
    // クリックするとき、提供される(実行される)メソッド (didSelectRowAt)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row == 0 {
            // Storyboard基盤でコードを持ってくるのが可能
            //意味説明: name: ~ になっているStoryboardから identifier ~ の名前になっているViewControllerを持ってこい！って意味
            // 今回は、Optional Unwrappingを用いて Unwrappingした
            if let generalVC = UIStoryboard(name: "GeneralViewController", bundle: nil).instantiateViewController(identifier: "GeneralViewController") as? GeneralViewController {
                // navigationControllerを用いてくくったから、navigationControllerのメッソドを使って、画面移動を実現できる
                // その画面に移動する -> pushViewController
                
                self.navigationController?.pushViewController(generalVC, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // cellForRowAt: どんなcellを表示するのかを意味する
        // IndexPath: TableViewの順番に関する部分
        
        //ここで、どの部分のcellがどのようなcellであるかを表示する設定ができる
        // 例えば、1行目は　ProfileCellで、それ以外の他の行はMenuCellの一環が出れればいい
        // -> それは、indexPathで設定できる
        if indexPath.section == 0 {
            // ここでは、sectionの区分せずにただのrowだけで処理を行うコードとなっている
            // 強制Type Castingが必要
            // なぜかというと、下記で定めたcellは UITableViewCellなので、ProfileCellを持ってくる必要がある
            // dequeueReusableCellは、基本的にUITableViewCellをreturnする
            // そのため、type castingを通じて、ここで指定したprofileCellを持ってくる必要がある
            
            
            //UIImageの後に ただのnamedだったら、projectのファイルに入れたイメージファイルだけを読み込むコード
            // 一方、systemNameだったら、SF Symbolsから探したファイル名をそのまま使える
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
            cell.topTitle.text = settingModel[indexPath.section][indexPath.row].menuTitle
            cell.profileImageView.image = UIImage(systemName: settingModel[indexPath.section][indexPath.row].leftImageName)
            cell.bottomDescription.text = settingModel[indexPath.section][indexPath.row].subTitle
            
            return cell
        }
        
        
        //UIImageは、optional　値が入るとだめ！
        //そのため、Optional Unwrapping をしてからparameterに引き渡すのが正しい
        // イメージ自体の色を変えたい場合は、tintColorで設定
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        
        cell.leftImageView.image = UIImage(systemName:settingModel[indexPath.section][indexPath.row].leftImageName)
        cell.leftImageView.tintColor = .red
        cell.middleTitle.text = settingModel[indexPath.section][indexPath.row].menuTitle
        cell.rightImageView.image = UIImage(systemName: settingModel[indexPath.section][indexPath.row].rightImageName ?? "")
        
        
        return cell
    }
    
    // あくまで、cellの高さの調整である
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            //一回目のrowは自動的に大きさが決まった通りそのままにするよ！というコード
            // その当該cellの高さのsizeは、そのcellが持つべきの分だけ自動に設定されるということ
            return UITableView.automaticDimension
        }
        return 60
    }
    
    
    //高さ(Height)をcustomサイズで設定させるfunction
//    // 直接指定の方法: 高さを開発者が固定の値で設定させたい！場合
//    // heightForRowAt: 当てはまるrowごとに高さを指定したい
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 80
//        // 全てのcellの高さが80になる
//    }
    
    
}
