//
//  TodoDetailViewController.swift
//  TodoApp
//
//  Created by Kyus'lee on 2022/07/29.
//

import UIKit
import CoreData

// NSPredicate: CoreDataの条件文
// 役割: SQL文の WHERE文と同様の条件文 -> 検索条件の指定

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
    
    
    @IBOutlet weak var saveButton: UIButton!
    
    
    // 既存のデータがないときに、deleteボタンは要らないため、既存のデータがあるときだけ、このボタンが表示されるように設定する
    @IBOutlet weak var deleteButton: UIButton!
    
    
    var priority: PriorityLevel?
    var selectedTodoList: TodoList?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // dataがあるかどうかのcheckをする
        // このcheck作業が終わってからviewDidLoadにつながるlife Cycle
        if let hasData = selectedTodoList {
            titleTextField.text = hasData.title
            priority = PriorityLevel(rawValue: hasData.prorityLevel)
            makePriorityButtonDesign()
            
            // dataがあるときだけ、deleteボタンが表示される
            // UIButtonの隠し: isHidden
            deleteButton.isHidden = false
            
            // dataがあるときに、dataを持ってくるのは、"update"という文字が表示されるように
            saveButton.setTitle("Update", for: .normal)
            
        } else {
            deleteButton.isHidden = true
            saveButton.setTitle("Save", for: .normal)
        }
        
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
        // priorityを確認して、layout designが決まるように、designの部分を他の間数で管理するようなコードを作成する
//        switch sender.tag {
//        case 1:
//            priority = .level1
//            lowButton.backgroundColor = priority?.color
//        case 2:
//            priority = .level2
//            normalButton.backgroundColor = priority?.color
//        case 3:
//            priority = .level3
//            highButton.backgroundColor = priority?.color
//        default:
//            break
//        }
        
        switch sender.tag {
        case 1:
            priority = .level1
        case 2:
            priority = .level2
        case 3:
            priority = .level3
        default:
            break
        }
        
        makePriorityButtonDesign()
    }
    
    // layout design設定の間数
    func makePriorityButtonDesign() {
        lowButton.backgroundColor = .clear
        normalButton.backgroundColor = .clear
        highButton.backgroundColor = .clear
        
        switch self.priority {
        case .level1:
            lowButton.backgroundColor = priority?.color
        case .level2:
            normalButton.backgroundColor = priority?.color
        case .level3:
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
        // save と updateの分岐点を指定
        if selectedTodoList != nil {
            updateTodo()
        } else {
            saveToDo()
        }
        // save 後、tableViewの画面を更新する
        delegate?.didFinishSaveData()
        
        // presentで画面を表示させるから
        self.dismiss(animated: true, completion: nil)
    }
    
    func saveToDo() {
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
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        appDelegate.saveContext()
    }
    
    func updateTodo() {
        guard let hasData = selectedTodoList else {
            return
        }
        
        let fetchRequest: NSFetchRequest<TodoList> = TodoList.fetchRequest()
        
        // uuidがないときもあるから、あろときだけ、以下の処理を進めるようにする
        guard let hasUUID = hasData.uuid else {
            return
        }
        // selectしたものだけを読み込む
        // uuid Type: CVarArg
        // Type Castingが必須である
        // %@: 文字列の指定
        fetchRequest.predicate = NSPredicate(format: "uuid = %@", hasUUID as CVarArg)
        do {
            //当てはまるものだけ、持ってくる
            let loadedData = try context.fetch(fetchRequest)
            
            // 当てはまるuuidが複数ある可能性もあるため、loadedData は、配列型の[TodoList]を返す。
            // そのため、loadedDataの配列の最初の値を扱うとし、firstを入れるのである
            loadedData.first?.title = titleTextField.text
            // Date()のdefault値は、現在のdateである。
            loadedData.first?.date = Date()
            // もし、priorityを指定せずに、saveしたのであれば、default値としてpriorityLevel1にする (優先度: 低め low)
            loadedData.first?.prorityLevel = self.priority?.rawValue ?? PriorityLevel.level1.rawValue
            
            let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
            appDelegate.saveContext()
            
        } catch {
            print(error)
        }
        
    }
    
    @IBAction func deleteTodo(_ sender: UIButton) {
        guard let hasData = selectedTodoList else {
            return
        }
        
        guard let hasUUID = hasData.uuid else {
            return
        }
        
        let fetchRequest: NSFetchRequest<TodoList> = TodoList.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "uuid = %@", hasUUID as CVarArg)
        
        do {
            let loadedData = try context.fetch(fetchRequest)
            
            if let loadFirstData = loadedData.first {
                context.delete(loadFirstData)
                
                //⚠️以下のコードを書かないと、appを再起動すると、deleteしたものが反映されず、また表示されてしまう。
                let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
                appDelegate.saveContext()
            }
            
            
        } catch {
            print(error)
        }
        
        delegate?.didFinishSaveData()
        self.dismiss(animated: true)
    }
    
    

}
