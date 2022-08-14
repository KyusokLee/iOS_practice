//
//  ViewController.swift
//  TableViewPrac
//
//  Created by Kyus'lee on 2022/08/14.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var customTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        customTableView.delegate = self
        customTableView.dataSource = self
        
        //nibファイルの場合、TableViewへの登録が必要である
        customTableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        customTableView.separatorStyle = .none
    }


}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
        
        // cellの間にある、lineを消す
        cell.selectionStyle = .none
        
        cell.contentView.layer.cornerRadius = 20
        cell.contentView.layer.masksToBounds = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    
}

