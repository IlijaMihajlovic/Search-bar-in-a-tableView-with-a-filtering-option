//
//  ViewController.swift
//  SearchBar
//
//  Created by Ilija Mihajlovic on 8/28/19.
//  Copyright © 2019 Ilija Mihajlovic. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    let searchBar = UISearchBar()
    
//    let data = [
//        Countries(countryName: "Germany"),
//        Countries(countryName: "Sweden"),
//        Countries(countryName: "Japan"),
//        Countries(countryName: "USA"),
//        Countries(countryName: "UK")
//    ]
    
    let data = ["Germany", "Sweden", "UK","Japan", "USA", "Canada"]
    
    var searchCountry  = [String]()
    var isSearching = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configureUI()
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    @objc func handleShowSearch() {
        showSearchBar(shouldShow: true)
        searchBar.becomeFirstResponder()
        searchBar.delegate = self
    }
    
    func configureUI() {
        searchBar.sizeToFit()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Search Bar"
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.barTintColor = .lightGray
        showSearchBarButtonItem(shouldShow: true)
        
    }
    
    func showSearchBarButtonItem(shouldShow: Bool) {
        
        if shouldShow {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(handleShowSearch))
        } else {
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    
    func showSearchBar(shouldShow: Bool) {
        
        //If the search bar is shown then disable the bar button item(the opposite of the argument shouldShow)
        showSearchBarButtonItem(shouldShow: !shouldShow)
        searchBar.showsCancelButton = shouldShow
        navigationItem.titleView = shouldShow ? searchBar: nil
        
        //Longer version
        //        if shouldShow == true {
        //            navigationItem.titleView = searchBar
        //        } else {
        //            navigationItem.titleView = nil
        //        }
        
    }
    
}

extension ViewController: UISearchBarDelegate{
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        showSearchBar(shouldShow: false)
        searchBar.text = ""
        isSearching = false
        animateTableViewWhileReloading()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text != "" {
            searchCountry = data.filter({$0.lowercased().uppercased().prefix(searchText.count) == searchText.lowercased().uppercased()})
            
//            data.forEach{ (myData) in
//                searchCountry = [myData.countryName.filter({$0.lowercased().uppercased().prefix(searchText.count) == searchText.lowercased().uppercased()})]
//            }
            
            
        }
        
        
        
        
        isSearching = true
        animateTableViewWhileReloading()
    }
    
    
    
    fileprivate func animateTableViewWhileReloading() {
        UIView.transition(with: tableView,duration:0.27,options:.transitionCrossDissolve,animations: { () -> Void in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }, completion: nil)
    }
    
}


//MARK: - TableView Data Source and Delegate Methods
extension ViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearching {
            return searchCountry.count
        } else {
            return data.count
        }
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //let countries = data[indexPath.row]
        
        if isSearching {
            cell.textLabel?.text = searchCountry[indexPath.row]
        } else {
            cell.textLabel?.text = data[indexPath.row]
            //cell.textLabel?.text = countries.countryName
        }
        
        
        return cell
    }
}


