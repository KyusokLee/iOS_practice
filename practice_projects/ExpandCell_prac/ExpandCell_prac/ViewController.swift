//
//  ViewController.swift
//  ExpandCell_prac
//
//  Created by Kyus'lee on 2022/08/08.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var expandTableView: UITableView!
    
    // 再現したいデータ構造
    // 必要なテキストを含む
    // expand　状態
    
    // Model
    struct ExpandDataModel {
        var description: String
        var isExpand: Bool
    }
    
    var dataModelArray = [ExpandDataModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        expandTableView.delegate = self
        expandTableView.dataSource = self
        
        let textArray = ["short Text",
                         "long long long long long long long long long long long long long long long long Text",
                         "short Text",
                         "long long long long long long long long long long long long long long long long Text",
                         "short Text",
                         "long long long long long long long long long long long long long long long long Text"]
        
        for (_, value) in textArray.enumerated() {
            dataModelArray.append(ExpandDataModel.init(description: value, isExpand: false))
        }
        
    }


}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataModelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpandCell_ID", for: indexPath) as! ExpandCellTableViewCell
        
        // indexPath.rowは、0からstart
        cell.descriptionLabel.text = dataModelArray[indexPath.row].description
        
        if dataModelArray[indexPath.row].isExpand {
            // numberOfLines: labelのtextのlineの数
            // 0: 格納されている全てを表示
            cell.descriptionLabel.numberOfLines = 0
        } else {
            cell.descriptionLabel.numberOfLines = 1
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    // 以下の方法は、よくない
    // ⁉️理由: 格納されているtextの量に合わせて、cellのheightが動的に増えるようにしなきゃいけないから
//    // heightForRowAtパラメータがあるメソッドを用いて直接数値を入れる方法
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return dataModelArray[indexPath.row].isExpand ? 150: 50
//    }
    
    // clickしたときのeventを担当するメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        // trueはfalseに、　falseは trueに
//        dataModelArray[indexPath.row].isExpand = !dataModelArray[indexPath.row].isExpand
        
        // toggleメソッドで簡単に実装可能
        dataModelArray[indexPath.row].isExpand.toggle()
        
        
        // Animation効果を与え、自然にcellのheightを変えるように
        // 1. heightForRowAt -> 正確な高さの値を指定することで、確実に解決
        
        // 2. tableView.reloadData() -> 状況によって、解決できる可能性
        
        // 3. 状況によって、解決できる可能性 -> header, footerがないとき
        //tableView.estimatedSectionHeaderHeight = 0
        //tableView.estimatedSectionFooterHeight = 0
        
        // 4. Animation効果をなくす
        // 現在のviewのすべてのanimation効果をなくすというコード
//        UIView.setAnimationsEnabled(false)
//        tableView.reloadRows(at: [indexPath], with: .none)
//        UIView.setAnimationsEnabled(true)
        
        // Animation効果を与え、自然にcellのheightを変えるように
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    
    
    
}
