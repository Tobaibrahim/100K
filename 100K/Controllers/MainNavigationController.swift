//
//  MainNavigationController.swift
//  100K
//
//  Created by TXB4 on 10/01/2021.
//



import UIKit



class MainNavigationController: UINavigationController {
    
    
    //MARK: - properties
    
    
    //MARK: - LifeCycle

    
    override func viewDidLoad() {
        configureViewControllers()
    }
    
    //MARK: - Helpers

    
    func configureViewControllers() {
//        fetchUsers()
        
        let shopDatacontroller      = ShopDataController()
        shopDatacontroller.title    = "Shop Items"
        let savedShopsController    = SavedShopsController()
        savedShopsController.title  = "Saved Shops"
        let searchShopsController   = SearchShopsController()
        searchShopsController.title = "Search"
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor     = .systemGray5
        appearance.titleTextAttributes = [.foregroundColor: UIColor.systemGray5]
        navigationBar.isTranslucent    = false
        viewControllers                = [searchShopsController,shopDatacontroller,savedShopsController]
        UINavigationBar.appearance().shadowImage  = UIImage()
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
       
        }

        
    
}
