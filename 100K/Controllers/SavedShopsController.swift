//
//  ViewController.swift
//  100K
//
//  Created by TXB4 on 06/01/2021.
//

import UIKit
import Firebase
import SafariServices


class SavedShopsController: UIViewController {
    
    
    // MARK: - Properties
    
    weak var delegate:ShopSelectionDelegate!

    
    var searchArray           = [String]() // save this to the database/ this changes depending on the shop searched and saved shop selected
    var counts                : [String: Int] = [:]
    var newArrayItems         = [String]()
    var shopName              = String()

    
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
    
    
    let placeHolderImage: UIImageView = {
       let image = UIImageView()
        image.setDimensions(width: 357, height: 252)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = #imageLiteral(resourceName: "placeholder")
        return image
    }()
    
    

    
    var shopImageUrl: String! {

        didSet {
            guard let safeResponse = shopImageUrl else {return}
            AuthService.shared.createShopImageUrls(key: shopName, value: safeResponse) // save shopname to database when the network request is done
            fetchDatabaseShopImageUrls()
        }

    }
    
    
    var databaseKeysResponse: [String]! {

        didSet {
            print("DEBUG:DATABASE KEYS SET")
            guard let safeResponse   = databaseKeysResponse else {return}
            print("DEBUG: KEYS = \(safeResponse)")
            fetchDatabaseShopImageUrls()

//            DispatchQueue.main.async {self.tableView.reloadData()}
        }

    }
    
    
    var shopImageUrlResponse: [String]! {

        didSet {
            print("DEBUG: testArrayResponse SET")
            tableView.dataSource   = self
            DispatchQueue.main.async {self.tableView.reloadData()}
        }

    }
    

    
    // MARK: - LifeCycle

  
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()

    }

    
    
    // MARK: - Requests
    
    
    func fetchDatabaseArray() {
        
        UserService.shared.fetchShopKeysArray() { [weak self] (results) in
            guard let self = self else {return}
            self.databaseKeysResponse = results
        }
    }
    
   private func fetchDatabaseShopImageUrls() {
        UserService.shared.fetchShopImageUrls() { [weak self] (results) in
            guard let self = self else {return}
            self.shopImageUrlResponse = results
        }
    }
    
    
    
    func downloadShopImageURL() {
        NetworkManager.shared.getShopImage(for: shopName) { (results) in
            switch results {
            case .success(let success):
                self.shopImageUrl = success
            case .failure(let error):
                print("DEBUG: ERROR = \(error)")
            }
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

            tableView.frame        = view.bounds
            tableView.delegate     = self
            view.addSubview(tableView)

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
        return shopImageUrlResponse.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        let cell =  tableView.dequeueReusableCell(withIdentifier: SavedShopCell.reuseID) as! SavedShopCell
        cell.titleLabel.text = databaseKeysResponse[indexPath.row]
        cell.editImageView.downloadImage(from: (shopImageUrlResponse[indexPath.row]))
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
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        guard editingStyle == .delete else {return}
        
        let path = databaseKeysResponse[indexPath.row]
        shopImageUrlResponse.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .left)
        AuthService.shared.deleteShop(key: path)
        fetchDatabaseArray()
        print(indexPath.row)
    }
    
}




// MARK: - Delegate Methods

extension SavedShopsController:ShopSelectionDelegate {
    func didAddShop(shopName: String) {
        self.shopName = shopName
        AuthService.shared.updateShopListingArray(key: shopName, value: [""] ) // Find a way to optimise this
        AuthService.shared.createHoldingValues(key: shopName, value: [""])
        downloadShopImageURL()
        fetchDatabaseArray()
    }
}

