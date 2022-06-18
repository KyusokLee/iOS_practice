//
//  GeneralViewController.swift
//  Setting_Clone_App
//
//  Created by Kyus'lee on 2022/06/17.
//

import UIKit

//ファイル１つに１つのclassがあるのが効率いいコードの作成方法ではあるが、ここのクラス以外にどこにも従属されないんだったら、下記のように該当ファイルで作っても別に問題にはならない
// 今回の場合は、cellをtableViewにコードで生成したのではなく、直接画面の上に載せたため、tableViewにcellをregisterするコードは省略可能となる
class GeneralCell: UITableViewCell {
    @IBOutlet weak var leftLabel: UILabel!
    
    @IBOutlet weak var rightImageView: UIImageView! {
        // didSet: 画面のimageとコードが連結される時点で、didSetが実行される感じ
        // 最初は、rightImageViewはnilだったが、didSetを実行してからobjectが生成されるのである
        // xibファイルと連結される時点に、didSetが呼び出される構造
        didSet{
            rightImageView.image = UIImage(systemName: "chevron.right")
            // chevron.rightの基本tintColor = blueである
            rightImageView.backgroundColor = .clear
            rightImageView.tintColor = .orange
        }
    }
}

// modelも今回の場合は、同じく一つのファイルで全部定義しておいた -> ❗️いい方法ではない！
// しかし、比較的にコードが短くて、ここのclass以外に他のどこでも使わないんだったら、可能ではある
struct GeneralModel {
    var leftTitle: String = ""
}

//今回の場合は、extensionでの定義ではなく、共に定義する方法でやってみた

class GeneralViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var model = [[GeneralModel]]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GeneralCell", for: indexPath) as! GeneralCell
        cell.leftLabel.text = model[indexPath.section][indexPath.row].leftTitle
        
        return cell
        
    }
    

    @IBOutlet weak var generalTableView: UITableView!
    
    
    // クリックしたいcellをクリックしてそのcellの詳細について見たい場合は、viewDidLoad()が消されてまた、生成されるから以下のままのコードでいいが、mainの場合はnavigationControllerが維持されるため、最初に設定しておいた LargeTitleがなくなる
    // そのため、viewWillAppearを使う必要がある
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "General"
        // navigationControllerは Optinal Class
        //しかし、このtitleを使いたい場合と使いたくない場合がある
        // 上記の書き方だとscroll動作に関わらず、全部titleが表示される
        // 今回は、tableViewの最も上のtextに Generalという文字が表示されないように設定しておく
        // 下記の書き方で再現できる
        navigationController?.navigationBar.prefersLargeTitles = false // false でlargeTitleが出なくなる
        
        generalTableView.delegate = self
        generalTableView.dataSource = self
        generalTableView.backgroundColor = UIColor(white: 245/255, alpha: 1)
        model.append([GeneralModel(leftTitle: "About")])
        model.append([GeneralModel(leftTitle: "Keyboard"),
                       GeneralModel(leftTitle: "Game Controller"),
                       GeneralModel(leftTitle: "Fonts"),
                       GeneralModel(leftTitle: "Language & Region"),
                       GeneralModel(leftTitle: "Dictionary")])
        
        model.append([GeneralModel(leftTitle: "Reset")])
        
    }


}
