//
//  ViewController.swift
//  100K
//
//  Created by TXB4 on 06/01/2021.
//

import UIKit
import Firebase
import SafariServices
import AudioToolbox



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
    
    

    
    // MARK: - UI
    
    func configureUI() {
        tableView.contentSize.height = 200
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        tableView.addGestureRecognizer(longPress)
        fetchDatabaseArray()
        
        let addButton          = UIBarButtonItem(image: SFSymbols.addButton, style: .done, target: self, action:#selector(addButtonPressed))
        addButton.tintColor    = .appPurple
        view.backgroundColor   = .systemGray5
        navigationItem.rightBarButtonItem  = addButton
        navigationItem.hidesBackButton     = true
        
        let tap = UITapGestureRecognizer(target: self.view, action:#selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        tableView.addGestureRecognizer(tap)
        
        tableView.frame        = view.bounds
        tableView.delegate     = self
        tableView.contentInset.bottom = 80 // space to the bottom of the tableview
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
    
    
    
    @objc func handleLongPress(sender: UILongPressGestureRecognizer) {
        
        if sender.state == UIGestureRecognizer.State.began {
            let touchPoint = sender.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                let namePath = databaseKeysResponse[indexPath.row]
                guard let url = URL(string: "https://www.etsy.com/uk/shop/\(namePath)") else {return}
                presentSafariVC(with: url)
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                print("DEBUG: \(indexPath)")
                // your code here, get the row for the indexPath or do whatever you want
                print("Long press Pressed:)")
            }
        }
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
        databaseKeysResponse.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .left)
        AuthService.shared.deleteShop(key: path)
        fetchDatabaseArray()
        print(indexPath.row)
    }
    
}




// MARK: - Delegate Methods

extension SavedShopsController:ShopSelectionDelegate {
    func didAddShop(shopName: String,shopImage:String) {
        self.shopName = shopName
        AuthService.shared.updateShopListingArray(key: shopName, value: [""] ) // Find a way to optimise this
        AuthService.shared.createHoldingValues(key: shopName, value: [""])
        shopImageUrl = shopImage
        fetchDatabaseArray()
    }
}

