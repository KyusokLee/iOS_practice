//
//  TodoDetailViewController.swift
//  TodoApp
//
//  Created by Kyus'lee on 2022/07/29.
//

import UIKit
import CoreData

//protocolを用いて画面を更新するdelegateを作成
protocol TodoDetailViewControllerDelegate: AnyObject {
    func didFinishSaveData()
}


class TodoDetailViewController: UIViewController {
    // weakにしたいなら、protocolがAnyObjectである必要がある
    weak var delegate: TodoDetailViewControllerDelegate?
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var lowButton: UIButton!
    
    @IBOutlet weak var normalButton: UIButton!
    
    @IBOutlet weak var highButton: UIButton!
    
    var priority: PriorityLevel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // ボタンを丸くする -> cornerRadius
    // ⚠️ viewDidLoadとかIBOutlet変数の生成時に、書かない理由
    // -> 画面を載せる前に、設定してしまうと、綺麗に反映されない場合がある
    //　そのため、画面が描かれた後に設定を行う方がより安全
    // viewDidLayoutSubviews: layoutに関するlifecycle メソッド
    // viewDidLayoutSubviewsの役割: viewがsubviewの配置を完了したということをview Controllerに知らせる
    // overrideして使う場合:
    // 1. 他のviewたちのコンテンツを Update
    // 2. viewたちのサイズや位置を最終的に調整
    // 3. tableのデータをreload
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // bounds.height の半分にすると、ナチュラルな丸いボタンを作れる
        lowButton.layer.cornerRadius = lowButton.bounds.height / 2
        normalButton.layer.cornerRadius = normalButton.bounds.height / 2
        highButton.layer.cornerRadius = highButton.bounds.height / 2

    }
    
    @IBAction func setPriority(_ sender: UIButton) {
        
        lowButton.backgroundColor = .clear
        normalButton.backgroundColor = .clear
        highButton.backgroundColor = .clear
        
        
        switch sender.tag {
        case 1:
            priority = .level1
            lowButton.backgroundColor = priority?.color
        case 2:
            priority = .level2
            normalButton.backgroundColor = priority?.color
        case 3:
            priority = .level3
            highButton.backgroundColor = priority?.color
        default:
            break
        }
    }
    
    // Xボタンを押したら、dismiss
    @IBAction func dismissButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func saveTodo(_ sender: Any) {
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        let context = appDelegate.persistentContainer.viewContext
        
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "TodoList", in: context) else {
            return
        }
        
        // Core Dataに作成したモデルの形をそのまま持ってくる
        // type castingが可能であるか否かをguard letを用いてcheckする
        guard let object = NSManagedObject(entity: entityDescription, insertInto: context) as? TodoList else {
            return
        }
        
        object.title = titleTextField.text
        // 保存saveをするときの日付をそのまま、entityに入れたいなら
        object.date = Date()
        //Uniqueな識別子 (id)
        object.uuid = UUID()
        
        // default valueを、level1のrawValueにする
        object.prorityLevel = priority?.rawValue ?? PriorityLevel.level1.rawValue
        
        // save処理
        appDelegate.saveContext()
        
        // save 後、tableViewの画面を更新する
        delegate?.didFinishSaveData()
        
        // presentで画面を表示させるから
        self.dismiss(animated: true, completion: nil)
        
        
        
        
        
    }
    

}
