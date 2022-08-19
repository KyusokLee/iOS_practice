//
//  ViewController.swift
//  TableViewPrac
//
//  Created by Kyus'lee on 2022/08/14.
//

import UIKit

// tableViewの Styleを inset groupにすることで、cell間の間隔を与えることができた

class ViewController: UIViewController {
    var term = ""
    let dataModels: [String] = ["Go to Library",
                                "Go to School",
                                "Have a breakfast",
                                "Just have a break time",
                                "Practice_longlonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglong",
                                "Finish",
                                "Prepare for Next Day"]
    
    @IBOutlet weak var customTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customTableView.delegate = self
        customTableView.dataSource = self
        
        //nibファイルの場合、TableViewへの登録が必要である
        customTableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        customTableView.separatorStyle = .none
//        // 左と右のmarginを与える
        customTableView.layoutMargins = .init(top: 0, left: 10, bottom: 0, right: 10)
        // searchBar を作って入れる方法
//        let searchBar = UISearchBar()
//        searchBar.placeholder = "Search"
//        self.navigationItem.titleView = searchBar
        
        searchBarConfigure()
        addNotification()
    }
    
    
    
    func searchBarConfigure() {
        // searchController の中にSearch Barがある
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.automaticallyShowsCancelButton = true
        searchController.searchResultsUpdater = self
        self.navigationItem.searchController = searchController
        self.navigationItem.title = "Search"
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        dump(searchController.searchBar.text)
    }
    
    
}
