//
//  ViewController.swift
//  100K
//
//  Created by TXB4 on 06/01/2021.
//

import UIKit
import Firebase


class SavedShopsController: UIViewController {
    
    
    // MARK: - Properties
    
    weak var delegate:ShopSelectionDelegate!

    
    var searchArray           = [String]() // save this to the database/ this changes depending on the shop searched and saved shop selected
    var counts                : [String: Int] = [:]
    var newArrayItems         = [String]()
    var shopImageUrl          = String() // save url string to database the download image from url???

    
//    let searchBar:UISearchBar = {
//        let searchBar         =  UISearchBar(frame: .zero)
//        searchBar.translatesAutoresizingMaskIntoConstraints = false
//        searchBar.placeholder = "Search"
//        return searchBar
//    }()
    
    let tableView: UITableView = {
        let tv = UITableView()
        tv.separatorColor      = .systemGray
        tv.backgroundColor     = .systemGray5
        tv.rowHeight           = 85
        tv.register(SavedShopCell.self, forCellReuseIdentifier: SavedShopCell.reuseID)
        tv.sectionIndexColor   = .systemGray6
        tv.allowsSelection = true
        return tv
    }()
    
    
    
    var databaseKeysResponse: [String]! {

        didSet {
            print("DEBUG:DATABASE KEYS SET")
            guard let safeResponse   = databaseKeysResponse else {return}
            print("DEBUG: KEYS = \(safeResponse)")
            tableView.dataSource   = self
            DispatchQueue.main.async {self.tableView.reloadData()}
        }

    }
    
    

    
    
    // Make a network call and add the latest array of items to the "searchArray" - DONE
    // Check the database if it has an array, if it does then carry on, if it doesnt add the "searchArray" to the database - DONE
    // compare the "Search Array to the database array... index specific" - DONE
    // return the changed indexes for the new added items  - DONE
    // add those new items to the database -
    // display the items with a Int,String value in the tableview
    
    
    
    // MARK: - LifeCycle

  
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()

    }

    
    
    // MARK: - Requests
    
   

    // MARK: - Array Validation

    
    
    func fetchDatabaseArray() {
        
        UserService.shared.fetchShopKeysArray() { [weak self] (results) in
            guard let self = self else {return}
            self.databaseKeysResponse = results
        }
    }
    
    
    
    // MARK: - UI

    func configureUI() {
            fetchDatabaseArray()
            let addButton          = UIBarButtonItem(image: SFSymbols.addButton, style: .done, target: self, action:#selector(addButtonPressed))
            addButton.tintColor    = .systemBlue
            view.backgroundColor   = .systemGray5
            navigationItem.rightBarButtonItem  = addButton
            navigationItem.hidesBackButton     = true
            
            let tap = UITapGestureRecognizer(target: self.view, action:#selector(UIView.endEditing(_:)))
            tap.cancelsTouchesInView = false
            tableView.addGestureRecognizer(tap)
//            searchBar.delegate     = self
//            searchBar.sizeToFit()
            tableView.frame        = view.bounds
            tableView.delegate     = self
            view.addSubview(tableView)
//            view.addSubview(searchBar)
//            navigationItem.titleView = searchBar
            navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    
    // MARK: - Handlers
    
    @objc func addButtonPressed() {
        let destVC           = SearchShopsController()
        let navController    = UINavigationController(rootViewController: destVC)
        destVC.delegate      = self
        present(navController, animated: true)
    }
    
    
}

// MARK: - TableView

extension SavedShopsController:UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return databaseKeysResponse.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        let cell =  tableView.dequeueReusableCell(withIdentifier: SavedShopCell.reuseID) as! SavedShopCell
        cell.titleLabel.text = databaseKeysResponse[indexPath.row]
        cell.editImageView.downloadImage(from: shopImageUrl)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destVC                   = ShopDataController()
        let path                     = databaseKeysResponse[indexPath.row]
        print("DEBUG: PATH = \(path)")
        destVC.shopName              = path
        let navController            = UINavigationController(rootViewController:destVC)
        present(navController, animated: true)
    }
    
    
}

// MARK: - SearchBar

extension SavedShopsController: UISearchBarDelegate {
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        contactKey?.issearching  = true
//        searchBar.showsCancelButton = true
//        searchContacts = nameArray.filter({$0.prefix(searchText.count) == searchText})
//        tableView.reloadData()
//    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        
    }
    
    
}

// MARK: - Delegate Methods

extension SavedShopsController:ShopSelectionDelegate {
    func didAddShop(shopName: String) {
        AuthService.shared.updateShopListingArray(key: shopName, value: [""] ) // Find a way to optimise this
        AuthService.shared.createHoldingValues(key: shopName, value: [""])
        fetchDatabaseArray()
    }
}

//extension SavedShopsController:UpdateShopData {
//    func didAddShopData(shopName: String) {
//        guard let safeResponse   = databaseArrayResponse else {return}
//        self.shopName = shopName
//        getShopListings()
//        destVC.databaseArrayResponse = safeResponse.listingArray
//    }
//
//}
