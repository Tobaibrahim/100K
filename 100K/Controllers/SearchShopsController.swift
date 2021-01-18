//
//  SearchShopsController.swift
//  100K
//
//  Created by TXB4 on 10/01/2021.
//

import UIKit

class SearchShopsController: UIViewController {
    
    
    // MARK: - Properties
    
    weak var delegate:ShopSelectionDelegate!

    
    var searchedshopNames = [String]()
    var searchedshopUrls  = [String]()
    
    
    private let searchGlassImage:UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(systemName: "magnifyingglass")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        imageView.setDimensions(width: 30, height: 30)
        imageView.image = image
        return imageView
    }()
    
    private let searchContainer: UIView = {
        let container = UIView()
        container.backgroundColor = .lightGray
        container.layer.cornerRadius = 10
        container.alpha = 0.6
        return container
    }()
    
    private let tableViewContainer: UIView = {
        let container = UIView()
        container.backgroundColor = .lightGray
        container.layer.cornerRadius = 14
//        container.alpha = 0.6
        return container
    }()
    
    
    private let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Search for shops"
        sb.setImage(UIImage(), for: .search, state: .normal)
        sb.setSearchFieldBackgroundImage(UIImage(), for: .normal)
        sb.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        sb.alpha = 0.8
        return sb
    }()
    
    let tableView: UITableView = {
        let tv = UITableView()
        tv.separatorColor      = .systemGray
        tv.backgroundColor     = .systemGray5
        tv.rowHeight           = 85
        tv.register(SavedShopCell.self, forCellReuseIdentifier: SavedShopCell.reuseID)
        tv.sectionIndexColor   = .systemGray6
        tv.allowsSelection     = true
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    
    
    // MARK: - LifeCycle

  
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    
    // MARK: - UI
    
    func configureUI() {
        
        view.addSubview(searchContainer)
        view.addSubview(tableViewContainer)

        
        let addButton          = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(doneButton))
        addButton.tintColor    = .systemBlue
        view.backgroundColor   = .systemGray5
        navigationItem.rightBarButtonItem  = addButton
        navigationItem.hidesBackButton     = true
        
        let tap = UITapGestureRecognizer(target: self.view, action:#selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        navigationController?.navigationBar.prefersLargeTitles = false
        

        let padding:CGFloat = 20

        searchContainer.anchor(leading:view.leadingAnchor,trailing: view.trailingAnchor,paddingLeft: padding,paddingRight: padding,height: 50)
        searchContainer.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor, paddingTop: 10)
        tableViewContainer.centerX(inView: view, topAnchor: searchContainer.bottomAnchor, paddingTop: padding)
        tableViewContainer.anchor(leading:view.leadingAnchor,trailing: view.trailingAnchor,paddingLeft: padding,paddingRight: padding,height: view.frame.height / 1.5)
        
        searchContainer.addSubview(searchGlassImage)
        searchContainer.addSubview(searchBar)
        tableViewContainer.addSubview(tableView)
        tableView.frame        = tableViewContainer.frame
        tableView.addGestureRecognizer(tap)
        tableView.delegate     = self
        searchBar.delegate     = self
        tableView.isHidden = true
        tableViewContainer.isHidden = true
        
        tableView.anchor(top:tableViewContainer.topAnchor,leading: tableViewContainer.leadingAnchor,bottom: tableViewContainer.bottomAnchor,trailing: tableViewContainer.trailingAnchor)
//        tableView.anchor(top:tableViewContainer.topAnchor,leading: tableViewContainer.leadingAnchor,bottom: tableViewContainer.bottomAnchor,trailing: tableViewContainer.trailingAnchor,paddingTop: 5,paddingLeft: 5,paddingBottom: 5,paddingRight: 5) // with frame
        
        searchBar.anchor(top:searchContainer.topAnchor,leading:searchContainer.leadingAnchor,trailing: searchContainer.trailingAnchor,paddingTop: 10,paddingLeft: 55,paddingRight: 14,height: 30)
        searchGlassImage.centerY(inView: searchContainer)
        searchGlassImage.anchor(leading:searchContainer.leadingAnchor,paddingLeft: 15)
    }
    
    // MARK: - Get Shops
    
    func findShops(shopName:String) {
        searchedshopNames.removeAll()
        searchedshopUrls.removeAll()
        
        NetworkManager.shared.searchShop(for: shopName, pagination: "5") {[weak self]  result in
            guard let self = self else {return}
            switch result {
            case.success(let shopSearchresult):
                DispatchQueue.main.async {self.tableView.dataSource = self}
                for values in shopSearchresult.results {
                    guard let safeShopIcons = values.iconUrlFullxfull else {return}
                    self.searchedshopNames.append(values.shopName)
                    self.searchedshopUrls.append(safeShopIcons)
                    print("DEBUG TEST SEARCH = \(values.shopName)")
                    print("DEBUG SHOP URL = \(safeShopIcons)")

                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
                
            case.failure(let error):
                
                print("DEBUG: \(error.localizedDescription)")
                
            }
            
        }
    }
    
    
    // MARK: - Handlers

    @objc func doneButton() {
        dismiss(animated: true)
    }
    
}


// MARK: - TableView

extension SearchShopsController:UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedshopNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        let cell =  tableView.dequeueReusableCell(withIdentifier: SavedShopCell.reuseID) as! SavedShopCell
        cell.titleLabel.text = searchedshopNames[indexPath.row]
        cell.editImageView.downloadImage(from: searchedshopUrls[indexPath.row])
        cell.accessoryType = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let path = searchedshopNames[indexPath.row].lowercased()
        let urlPath = searchedshopUrls[indexPath.row]
        delegate.didAddShop(shopName: path, shopImage: urlPath)
        dismiss(animated: true)
    }
    
    
}

// MARK: - SearchBar

extension SearchShopsController:UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else {return}
        findShops(shopName: searchText)
        print("DEBUG: SEARCHED")
        tableView.isHidden = false
        tableViewContainer.isHidden = false

    }
    
}
