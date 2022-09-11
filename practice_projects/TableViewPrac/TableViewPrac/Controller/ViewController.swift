//
//  ViewController.swift
//  TableViewPrac
//
//  Created by Kyus'lee on 2022/08/14.
//

import UIKit

// tableViewの Styleを inset groupにすることで、cell間の間隔を与えることができた

class ViewController: UIViewController {
//    var likesState = [Int]()
    var term = ""
    let dataModels: [String] = ["Go to Library",
                                "Go to School",
                                "Have a breakfast",
                                "Just have a break time",
                                "Practice_longlonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglong",
                                "Finish",
                                "Prepare for Next Day"]
//    let roundButton: AnimationTestButton = {
//        var button = AnimationTestButton()
//        button.setImage(UIImage(systemName: "plus.circle"), for: .normal)
//        button.layer.cornerRadius = button.frame.height / 2
//        button.tintColor = .blue
//        // codeで直接constraintsの設定を可能とする
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
    
    @IBOutlet weak var customTableView: UITableView!
    
    // constraintsの設定は、addSubviewで追加した後に行わないと、errorになっちゃう
    // 🌈原因: UIの設定がないのに、位置を設定しようとしたため
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animationTestButton()
        setUpTableView()
        registerNib()
        setUpLayout()
        
        // searchBar を作って入れる方法
//        let searchBar = UISearchBar()
//        searchBar.placeholder = "Search"
//        self.navigationItem.titleView = searchBar
        
        searchBarConfigure()
        addNotification()
    }
    
    func animationTestButton() {
        let button = AnimationTestButton()
        let btnWidth: CGFloat = 70
        let btnHeight: CGFloat = 70
        
        guard let hasNewImage = button.resizingImage(width: btnWidth, height: btnHeight) else {
            return
        }
        
        button.frame = CGRect(x: self.view.frame.maxX - 90, y: self.view.frame.maxY - 180, width: btnWidth, height: btnHeight)
        button.setImage(hasNewImage, for: .normal)
        button.layer.cornerRadius = button.frame.height / 2
        button.addTarget(self, action: #selector(presentAnimationView), for: .touchUpInside)
        self.view.addSubview(button)
    }
    
    // LaunchVCをpresentするよう
    // storyboardであるため、nilファイルのpresent方法と多少異なる
    @objc func presentAnimationView() {
        //storyboard連結
        let animationStoryboard = UIStoryboard(name: "CustomAnimationTest", bundle: nil)
        // storyboardと連動しているViewcontrollerの連結
        let animationVC = animationStoryboard.instantiateViewController(withIdentifier: "LaunchVC") as! LaunchVC
        
        self.present(animationVC, animated: true)
        
    }
    
    func setUpTableView() {
        customTableView.delegate = self
        customTableView.dataSource = self
        // ⚠️このコードでsearch barがnavigation Controllerを隠すlayoutの変化が直ちに反映されるようになった -> でも、naturalじゃない
        // 解決策: searchbarが活性化になって、navigation barを隠すdurationは、keyboardのappear durationと全く一緒であった！
        // timerを調整するといいかも！
        customTableView.layer.needsDisplayOnBoundsChange = true
        customTableView.reloadData()
    }
    
    func registerNib() {
        //nibファイルの場合、TableViewへの登録が必要である
        customTableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
    }
    
    func setUpLayout() {
        customTableView.separatorStyle = .none
//        // 左と右のmarginを与える
        customTableView.layoutMargins = .init(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func searchBarConfigure() {
        // searchController の中にSearch Barがある
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.automaticallyShowsCancelButton = true
        searchController.searchResultsUpdater = self
        self.navigationItem.searchController = searchController
        self.navigationItem.title = "To Do"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.hidesSearchBarWhenScrolling = false
//        let cancel = UIBarButtonItem(systemItem: .cancel, primaryAction: UIAction(handler: { _ in
//            print("Cancel SearchBar")
//        }), menu: nil)
//
//        self.navigationItem.rightBarButtonItem = cancel
        
//        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 280, height: 0))
//        searchBar.placeholder = "Search"
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: searchBar)
    }
    
    func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func keyboardWillShow(noti: Notification) {
        
        
        
        
        
    }
    
    @objc func keyboardWillHide(noti: Notification) {
        
    }
    
    

}

//1つのsectionに１つのrowが入るように
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataModels.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
//
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    // 1つのsectionに1つのrowが入るように
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
        
        
        cell.titleLabel.text = dataModels[indexPath.section]
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // clickを２回されるとborderがなくならないようにしたい！
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        dump(searchController.searchBar.text)
    }
}

//extension ViewController: CustomCellDelegate {
//    func hartButtonClicked(for index: Int, like: Bool) {
//        if like == true {
//
//        } else {
//
//        }
//    }
//}
