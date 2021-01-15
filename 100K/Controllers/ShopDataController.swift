//
//  ShopDataController.swift
//  100K
//
//  Created by TXB4 on 10/01/2021.
//

import UIKit
import Firebase
import ProgressHUD

class  ShopDataController: UIViewController {
    
    
    weak var delegate:UpdateShopData!

    
    // MARK: - Properties
    

    var searchArray           = [String]() // save this to the database/ this changes depending on the shop searched and saved shop selected
    var counts                : [String: Int] = [:]
    var shopName              : String!
    var newArrayItems         = [String]()
    var shopImageUrl          = String() // save url string to database the download image from url???
    
    
    
    
    
    
    var databaseKeysResponse  : [String]! {

        didSet {
            print("DEBUG:DATABASE KEYS SET")
            guard let safeResponse   = databaseKeysResponse else {return}
            print("DEBUG: KEYS = \(safeResponse)")

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
            
//            if safeResponse.listingArray.isEmpty {
////                let empty:[String] = []
////                AuthService.shared.createHoldingValues(key: shopName, value: empty  )
//            }
            changedIndexValuesFromLoop()
            self.GetShopData()
            self.tableView.dataSource = self
            tableView.reloadData()
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
   
    
    var itemCount = [Int]()
    var itemName  = [String]()

    let tableView: UITableView = {
        let tv = UITableView()
        tv.separatorColor      = .systemGray
        tv.backgroundColor     = .systemGray5
        tv.rowHeight           = 85
        tv.register(ShopDataCell.self, forCellReuseIdentifier: ShopDataCell.reuseID)
        tv.sectionIndexColor   = .systemGray6
        tv.allowsSelection = true
        return tv
    }()
    
    let updateButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setTitle("Update", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 17
        button.backgroundColor = UIColor.systemBlue
        button.setTitleColor(UIColor(white: 1, alpha: 1),for: .normal)
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.addTarget(self, action: #selector(updateButtonPressed), for: .touchUpInside)
        return button
    }()
    
    
    
    // MARK: - LifeCycle
    
    
    override func viewDidLoad() {
        configureUI()
        getShopListings()

    }
    
    
    // MARK: - Requests
    
    func getShopListings() { // Search
        ProgressHUD.show()
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

    func changedIndexValuesFromLoop() {
        validateArray {[weak self](result) in
            guard let self = self else {return}
            print("DEBUG: CHANGED INDEX = \(result)")
            result.forEach { (value) in
                self.addNewItems(values: value)
            }
        }
        
    }
    
    
    
    // MARK: - Array Validation

    
    func addNewItems(values:Int) {
       
        newArrayItems.append(searchArray[values])   // index issue
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            AuthService.shared.createHoldingValues(key: self.shopName, value: self.searchArray)
        }
        
        var list = databaseArrayResponse.listingArray
        print("TEST REMOVE VAL = \(list.last!)")
        if list.last == "" {
            list.removeLast()
        }
        else {
            list.insert(contentsOf: self.newArrayItems, at: 0)
            AuthService.shared.updateShopListingArray(key: self.shopName, value: list) // Find a way to optimise this
        }
    }
        

    func validateArray(completion:@escaping([Int]) -> Void){
        
        var changedIndex         = [Int]() // value of index changes
        guard let safeHoldingArrayResponse   = databaseHoldingArray else {return}
        let difference           = safeHoldingArrayResponse.difference(from:searchArray[0..<safeHoldingArrayResponse.count]).insertions

        for values in difference { // we have to do this because the enums have the values we need then we append the
            switch values {
            case.insert(let offset, _, _):
                // this case gives me access to the changed values (offset)
                changedIndex.append(offset)

            case .remove(offset:_ , element: _, associatedWith:_):
                break
            }
        }
        print("DEBUG: CHANGED INDEX = \([changedIndex])")
       
            completion(changedIndex)
    }
    
    
    private func fetchDatabaseArray() {
        
        UserService.shared.fetchShopKeysArray() { [weak self] (results) in
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
    
    
    
    
    // MARK: - GetShopData
    
    func GetShopData() { // tableView
        counts.removeAll()
        itemName.removeAll()
        itemCount.removeAll()
        
        guard let safeResponse   = databaseArrayResponse else {return }
//        for item in safeResponse.listingArray {
//            counts[item] = (counts[item] ?? 0) + 1 // this will always tell me how many items are in the array and int value
//            for (key, value) in counts {
//                print("\(key) occurs \(value) time(s)")
//                itemName.append(key)
//                itemCount.append(String(value))
//            }
//        }
        
        
        let mappedItems = safeResponse.listingArray.map { ($0, 1) }
        let counts      = Dictionary(mappedItems, uniquingKeysWith: +)
        itemName.append(contentsOf: counts.keys)
        itemCount.append(contentsOf: counts.values)
        ProgressHUD.dismiss()


    }
    
    
    // MARK: - UI

    private func configureUI() {
        ProgressHUD.animationType = .circleStrokeSpin
        tableView.isHidden = true
        let exitButton          = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(exitButtonPressed))
        exitButton.tintColor    = .systemBlue
        navigationItem.rightBarButtonItem  = exitButton
        view.backgroundColor   = .systemGray5
        navigationItem.hidesBackButton     = true
        
        let tap = UITapGestureRecognizer(target: self.view, action:#selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        tableView.addGestureRecognizer(tap)
        tableView.frame        = view.bounds
        tableView.delegate     = self
        view.addSubview(tableView)
        view.addSubview(updateButton)
        navigationController?.navigationBar.prefersLargeTitles = false
        
        updateButton.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.bottomAnchor, paddingTop: -90)
        updateButton.anchor(leading:view.leadingAnchor,trailing: view.trailingAnchor,paddingLeft: 60,paddingRight: 60)
    }
    
    
    
    
// MARK: Selectors
    
    @objc func updateButtonPressed() {
        tableView.isHidden = false
        getShopListings()
        updateButton.isHidden = true

    }
    
    @objc func exitButtonPressed() {
        dismiss(animated: true)
    }

    
}



// MARK: - TableView

extension ShopDataController:UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return databaseArrayResponse.listingArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: ShopDataCell.reuseID) as! ShopDataCell
            cell.accessoryType   = .none

        cell.shopItemValueLabel.text = String(itemCount[indexPath.row])
        cell.titleLabel.text         = itemName[indexPath.row]
            
        return cell
    }
    
    
}
    
