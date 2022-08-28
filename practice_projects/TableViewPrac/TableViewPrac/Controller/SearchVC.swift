//
//  SearchVC.swift
//  TableViewPrac
//
//  Created by Kyus'lee on 2022/08/19.
//

import UIKit

class SearchVC: UIViewController {
    let countryDataModel = countryArray
    var filteredArray: [[String]] = []
    
    var isFiltering: Bool {
        let searchController = self.navigationItem.searchController
        let isActive = searchController?.isActive ?? false
        let searchBarHasText = searchController?.searchBar.text?.isEmpty == false
        return isActive && searchBarHasText
    }
    
    var searchController: UISearchController!
    
    @IBOutlet weak var countryTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        registerCell()
        searchBarConfigure()
        addKeyboardObserver()
    }
    
    // keyboard 옵저버는 single tone의 공유하는 오브젝트이기에, 꼭 remove를 해줘야함
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeKeyboardObserver()
    }
    
    func setUpTableView() {
        countryTableView.delegate = self
        countryTableView.dataSource = self
        countryTableView.contentInsetAdjustmentBehavior = .never
        countryTableView.reloadData()
    }
        
    func registerCell() {
        countryTableView.register(UINib(nibName: "SearchResultCell", bundle: nil), forCellReuseIdentifier: "SearchResultCellID")
    }
    
    func searchBarConfigure() {
        
        // SearchControllerを用いた方法
        searchController = UISearchController(searchResultsController: nil)
//        searchController.
//        searchController.showsSearchResultsController = true
        searchController.searchBar.placeholder = "国名を入力してください"
        
        // searchBarを活性化しても、Navigation Bar Titleを常に表示させるように
        searchController.hidesNavigationBarDuringPresentation = false
        // searchBarを開くとcancelボタンが自然なanimation効果とともに表示される
        searchController.automaticallyShowsCancelButton = true
        
        // 検索結果を直ちにUpdateしてくれるコード
        searchController.searchResultsUpdater = self
        self.navigationItem.searchController = searchController
        self.navigationItem.title = "Country Search"
        // 大文字のTitleにする
        self.navigationController?.navigationBar.prefersLargeTitles = true
        // Scrollをしても、searchBarが常に表示されるように
        self.navigationItem.hidesSearchBarWhenScrolling = false
        // 덮길 원하는 뷰 컨트롤러를 지정할 수 있다.
        definesPresentationContext = true
        
        // obscuresBackgroundDuringPresentation: 検索中に背景を暗くするコード
        searchController.obscuresBackgroundDuringPresentation = false
    }
    
    // 키보드가 나타나는 속도와 동시에 search bar을 위로 올리게끔 하기위해
    func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(noti: Notification) {
        let notiInfo = noti.userInfo!
        let animationDuration = notiInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        print(self.countryTableView.frame.height)
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(noti: Notification) {
        let notiInfo = noti.userInfo!
        let animationDuration = notiInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        print(self.countryTableView.frame.height)
        
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        self.viewSafeAreaInsetsDidChange()
//    }

}

extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.isFiltering ? self.filteredArray.count : self.countryDataModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCellID", for: indexPath) as! SearchResultCell
        
        if self.isFiltering {
            cell.countryNameLabel.text = self.filteredArray[indexPath.row][0]
        } else {
            cell.countryNameLabel.text = self.countryDataModel[indexPath.row][0]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
        
}

extension SearchVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let hasText = searchController.searchBar.text else {
            return
        }
        
        self.filteredArray = self.countryDataModel.filter { $0[0].localizedCaseInsensitiveContains(hasText) }
        dump(filteredArray)
        // filtering시키고, row의 data를 reload하게끔
        countryTableView.reloadData()
    }
}


//UIView.animate(withDuration: 1.0, animations: {
//        self.yourTable.frame = CGRect(x: self.yourTable.frame.origin.x, y: self.view.frame.height - self.yourTable.frame.height - <Where do you want go>, width: self.yourTable.frame.width, height: self.yourTable.frame.height)
//    })
