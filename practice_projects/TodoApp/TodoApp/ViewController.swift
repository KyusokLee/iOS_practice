//
//  ViewController.swift
//  TodoApp
//
//  Created by Kyus'lee on 2022/07/19.
//

import UIKit

//必要なlogic
// Navigation Controllerの barItemを用いて、内容追加
// アプリを終了しても、そのデータが消えずに残るように、CoreData(Local DB)を使う
// 追加した内容を、tableViewの　cellに表示
// 機能: Todoの内容の追加、削除、更新を可能とする
// 表示させたいUIを考慮する

// ⚠️Not Yet: 追加したい機能
// CalendarView, Alarm機能も追加する予定

class ViewController: UIViewController {
    
    @IBOutlet weak var toDoTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "To Do List"
        self.makeNavigationBar()
        toDoTableView.delegate = self
        toDoTableView.dataSource = self
        
        
    }
    
    func makeNavigationBar() {
        // systemが提供するButtonを使いたいから、barButtonSystemItemにした
        // .add: "+" 機能のボタン (image)
        let rightAddItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewToDo))
        
        rightAddItem.tintColor = .black
        navigationItem.rightBarButtonItem = rightAddItem
        
        //MARK: navigation領域の色の設定
        let barAppearance = UINavigationBarAppearance()
        // withAlphaComponentを用いて、色の濃度を設定可能
        barAppearance.backgroundColor = .blue.withAlphaComponent(0.2)
        
//        //直接colorを設定する方法
//        barAppearance.backgroundColor = UIColor(red: 30/255, green: 40/255, blue: 50/255, alpha: 0.3)
        
        // ❗️iOS15からは、scrollEdgeAppearanceも一緒に設定しなければ、navigation barの色が反映されない
        self.navigationController?.navigationBar.standardAppearance = barAppearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = barAppearance
    }
    
    @objc func addNewToDo() {
        
    }
    
    


}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath)
        
        return cell
    }
    
    
}
