//
//  ViewController.swift
//  Setting_Clone_App
//
//  Created by Kyus'lee on 2022/06/15.
//

import UIKit

// 🔥TableViewを使う時には、protocolを順守するSettingを設ける必要ががある: UITableViewDelegate, UITableViewDataSourceは必ず必要
// extensionを用いてclassのコードが長くなることを防ぐと同時に、読み手(自分を含めて)にとってわかりやすくする

class ViewController: UIViewController {
    // ⁉️Outlet Objectの変数名をrenameするときは、必ず referencing outletsで既存に作成したやつを削除すること!
    // ⁉️NSUnknownKeyExceptionエラーの解決方
    // ❗️Warning once only: Detected a case where constraints ambiguously -> 警告
    // ❗️原因: autoLayoutに対するcellの制約条件(constraints)が十分与えられてないため、table viewにcellのheightを知らせる警告である
    var settingModel = SettingModel()
    
    @IBOutlet weak var settingTableView: UITableView!
    
    func makeData() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //以下のコードを書かないと表示されない
        settingTableView.delegate = self
        settingTableView.dataSource = self
        
        // 🔥コードでTableViewControllerにTabelCellを登録する方法
        // 必ずcellをtableViewに登録させる -> しないと、crashになる
        settingTableView.register(UINib(nibName: "ProfileCell", bundle: nil), forCellReuseIdentifier: "ProfileCell")
        settingTableView.register(UINib(nibName: "MenuCell", bundle: nil), forCellReuseIdentifier: "MenuCell")
    }


}

// 内容がそんなに複雑でなく、かつ、散漫でない場合は、コンマ(,) を使って一緒に定めていい

// cellのheightを決められる-> UITableViewDelegateの中に定義されている
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // ここで、numberOfRowInSectionが指すのは、Cellの数である
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // cellForRowAt: どんなcellを表示するのかを意味する
        // IndexPath: TableViewの順番に関する部分
        
        //ここで、どの部分のcellがどのようなcellであるかを表示する設定ができる
        // 例えば、1行目は　ProfileCellで、それ以外の他の行はMenuCellの一環が出れればいい
        // -> それは、indexPathで設定できる
        if indexPath.row == 0 {
            // ここでは、sectionの区分せずにただのrowだけで処理を行うコードとなっている
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath)
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath)
        
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
