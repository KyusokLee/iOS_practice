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
    
    @IBOutlet weak var countryTableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        registerCell()
        searchBarConfigure()
    }
    
    func setUpTableView() {
        countryTableView.delegate = self
        countryTableView.dataSource = self
    }
    
    func registerCell() {
        countryTableView.register(UINib(nibName: "SearchResultCell", bundle: nil), forCellReuseIdentifier: "SearchResultCellID")
    }
    
    func searchBarConfigure() {
        // SearchControllerを用いた方法
        let searchController = UISearchController(searchResultsController: nil)
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
        // obscuresBackgroundDuringPresentation: 検索中に背景を暗くするコード
        searchController.obscuresBackgroundDuringPresentation = false
    }

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
        //更新
        self.countryTableView.reloadData()
    }


}
