//
//  ViewController.swift
//  TodoApp
//
//  Created by Kyus'lee on 2022/07/19.
//

import UIKit
import CoreData

// priorityごとの色の設定model
enum PriorityLevel: Int64 {
    case level1
    case level2
    case level3
}

extension PriorityLevel {
    var color: UIColor {
        switch self {
        case .level1:
            return .green
        case .level2:
            return .orange
        case .level3:
            return .red
        }
    }
}

//必要なlogic
// Navigation Controllerの barItemを用いて、内容追加
// アプリを終了しても、そのデータが消えずに残るように、CoreData(Local DB)を使う
// 追加した内容を、tableViewの　cellに表示
// 機能: Todoの内容の追加、削除、更新を可能とする
// 表示させたいUIを考慮する

// ⚠️Not Yet: 追加したい機能
// CalendarView, Alarm機能も追加する予定


// tableViewの構成: Header, Section, footer
// つまり、cellを表示するrowが集まってsectionになり、また、sectionが集まってtableViewになる構造
// それぞれのsectionは、Headerとfooterを持つことが可能
// sectionのheaderとfooterとは別途に、tableView自体もheaderとfooterを持つことが可能である

class ViewController: UIViewController {
    
    @IBOutlet weak var toDoTableView: UITableView!
    
    //MARK: AppDelegateへアクセスするlogic
    // single tone用いて、appdelegateのものを持ってくる
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    
    // 全域変数として定義 -> 保存されるように
    // localDB作成したentity名
    var todoList = [TodoList]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "To Do List"
        self.makeNavigationBar()
        toDoTableView.delegate = self
        toDoTableView.dataSource = self
        
        fetchData()
        // tableViewで全体のcell,sectionをupdate(更新)するのは、reloadData()メソッド
        // dataを読み込んで、画面に表示させる
        toDoTableView.reloadData()
    }
    
    // 最初にデータを読み込む間数
    // localDataBaseファイルで生成したentityをrequest
    func fetchData() {
        let fetchRequest: NSFetchRequest<TodoList> = TodoList.fetchRequest()
        
        let context = appdelegate.persistentContainer.viewContext
        
        do {
            self.todoList = try context.fetch(fetchRequest)
        } catch {
            print(error)
        }
        
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
        let detailVC = TodoDetailViewController.init(nibName: "TodoDetailViewController", bundle: nil)
        detailVC.delegate = self
        self.present(detailVC, animated: true, completion: nil)
    }
    
    


}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.todoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // typeCasting
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath) as! ToDoCell
        
        // cellのtoptitleLabelの文字を表示
        cell.topTitleLabel.text = todoList[indexPath.row].title
        
        // cellのdate値を表示
        // 1. まず、optional bindingをし、date値があるかどうかを確認
        if let hasDate = todoList[indexPath.row].date {
            // dataFormatterを用いて、表示したいdate形式をcustomizeする
            let formatter = DateFormatter()
            // ex) 2022-7-29 14:27:22
            formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
            
            // どのデータを基準にdate customizeするかを指定
            // DateFormatter().string(from: 基準のデータ)
            let dateString = formatter.string(from: hasDate)
            cell.dateLabel.text = dateString
        } else {
            // dateを正常に読み込むことができなかったとき
            cell.dateLabel.text = ""
        }
        
        let priority = todoList[indexPath.row].prorityLevel
        
        let priorityColor = PriorityLevel(rawValue: priority)?.color
        cell.priorityView.backgroundColor = priorityColor
        cell.priorityView.layer.cornerRadius = cell.priorityView.bounds.height / 2

        
        return cell
    }
    
}

extension ViewController: TodoDetailViewControllerDelegate {
    func didFinishSaveData() {
        //データを読み込んだ後、更新しなければいけない
        self.fetchData()
        self.toDoTableView.reloadData()
    }
}
