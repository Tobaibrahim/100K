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
    
    var searchArray           = [String]() // save this to the database/ this changes depending on the shop searched and saved shop selected
    var counts                : [String: Int] = [:]
    var shopName              = "PlannerKate1"
    var newArrayItems         = [String]()

    
    let searchBar:UISearchBar = {
        let searchBar         =  UISearchBar(frame: .zero)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Search"
        return searchBar
    }()
    
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
    
    
    var databaseHoldingArray: [String]! {

        didSet {
            print("DEBUG:DatabaseHoldingArray SET")
            guard let safeResponse   = databaseHoldingArray else {return}
            print("DEBUG: DatabaseHoldingArray = \(safeResponse)")
        }

    }
    
    
    var databaseArrayResponse: ShopListingArray! {
        
        didSet {
            print("DEBUG:DATABASE RESPONSE SET")
            guard let safeResponse   = databaseArrayResponse else {return}
            
            if safeResponse.listingArray == [""] {
                AuthService.shared.createShopListingArray(key: shopName, value: searchArray)
                AuthService.shared.createHoldingValues(key: shopName, value: [""])
            }
            else {changedIndexValuesFromLoop()}
            print("DEBUG:DATABASE RESPONSE  = \(safeResponse.listingArray)")
        }
        
    }
    
    
    var networkRequestArrayResponse: ListingsResponse! {
        
        didSet {
            print("DEBUG:DATA RESPONSE SET")
            guard let safeResponse   = networkRequestArrayResponse else {return}
            safeResponse.results.forEach { (result) in searchArray.append(result.title)}
            fetchDatabaseArray()
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
        getShopListings()
    }

    
    
    // MARK: - Requests
    
    func getShopListings() { // Search
        NetworkManager.shared.getListings(for: shopName) { [weak self](results) in
            guard let self = self else {return}
            switch results {
            case .success(let success):
                self.networkRequestArrayResponse = success
                
            case .failure(let error):
                print("DEBUG: Error = \(error.localizedDescription)")
            }
        }
    }
    

    // MARK: - Array Algorithm
    
    func sortArray() { // tableView
        
        guard let safeResponse   = databaseArrayResponse else {return}
        for item in safeResponse.listingArray {
            counts[item] = (counts[item] ?? 0) + 1 // this will always tell me how many items are in the array and int value
        }

        for (key, value) in counts {
            print("\(key) occurs \(value) time(s)")
            // use this for tableView
        }
        
    }
    
    func changedIndexValuesFromLoop() {
        validateArray {[weak self](result) in
            guard let self = self else {return}
            print("DEBUG: CHANGED INDEX = \(result)")
            result.forEach { (value) in
                self.addNewItems(values: value)
            }
            print("DEBUG: COUNT = \(self.databaseArrayResponse.listingArray.count)")
        }
    }
    
    
    // MARK: - Array Validation

    
    func addNewItems(values:Int) {
        newArrayItems.append(searchArray[values])
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {AuthService.shared.createHoldingValues(key: self.shopName, value: self.newArrayItems)}
        var list = databaseArrayResponse.listingArray
        list.insert(contentsOf: self.newArrayItems, at: 0)
        
        AuthService.shared.updateShopListingArray(key: self.shopName, value: (list)) // Find a way to optimise this
    }
        

    func validateArray(completion:@escaping([Int]) -> Void){
        // validates our array and makes sure that its not the same as the previous day.
        // match the database array to the searched array based on index
        // returns the index of changes
        // appends those index arrays to database
        
        var changedIndex         = [Int]() // value of index changes
        guard let safeResponse   = databaseArrayResponse else {return}
        guard let safeHoldingArrayResponse   = databaseHoldingArray else {return}
        let databaseArray        = safeResponse.listingArray
//        let a = safeHoldingArrayResponse + searchArray
        searchArray.insert(contentsOf: safeHoldingArrayResponse, at: 0)
        let difference           = databaseArray[0..<searchArray.count - 1].difference(from:searchArray).insertions
        // returns an array of values that are different in comparison
        // using 0... allows us to specify from index 0 to the search array max count.
//        searchArray = a
        for values in difference { // we have to do this because the enums have the values we need then we append the
            switch values {
            case.insert(let offset, _, _):
                // this case gives me access to the changed values (offset)
                changedIndex.append(offset)
            case .remove(offset:_ , element: _, associatedWith:_):
                break
            }
        }
        
         completion(changedIndex)
    }
    
    
    
    
    func fetchDatabaseArray() {
        
        UserService.shared.fetchShopKeysArray(name: shopName) { [weak self] (results) in
            guard let self = self else {return}
            self.databaseKeysResponse = results
        }
        
        UserService.shared.fetchShopListingsArray(name: shopName) {[weak self] (results)  in
            guard let self = self else {return}
            self.databaseArrayResponse = results
        }
        
        UserService.shared.fetchHoldingValuesArray(name: shopName) {[weak self] (results) in
            guard let self = self else {return}
            self.databaseHoldingArray = results

        }
    }

    
    // MARK: - UI

    func configureUI() {
    
            let addButton          = UIBarButtonItem(image: SFSymbols.addButton, style: .done, target: self, action:#selector(addButtonPressed))
            addButton.tintColor    = .systemBlue
            view.backgroundColor   = .systemGray5
            navigationItem.rightBarButtonItem  = addButton
            navigationItem.hidesBackButton     = true
            
            let tap = UITapGestureRecognizer(target: self.view, action:#selector(UIView.endEditing(_:)))
            tap.cancelsTouchesInView = false
            tableView.addGestureRecognizer(tap)
            searchBar.delegate     = self
            searchBar.sizeToFit()
            tableView.frame        = view.bounds
            tableView.delegate     = self
            view.addSubview(tableView)
            view.addSubview(searchBar)
            navigationItem.titleView = searchBar
            navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    
    // MARK: - Handlers
    
    @objc func addButtonPressed() {
        let destVC           = SearchShopsController()
        let navController    = UINavigationController(rootViewController: destVC)
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
        return cell
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
