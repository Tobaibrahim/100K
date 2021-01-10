//
//  ViewController.swift
//  100K
//
//  Created by TXB4 on 06/01/2021.
//

import UIKit
import Firebase


class ViewController: UIViewController {
    
    
    // MARK: - Properties
    
    
    var searchArray   = [String]() // save this to the database/ this changes depending on the shop searched and saved shop selected
    var counts        : [String: Int] = [:]
    var shopName      = "PlannerKate1"
    var newArrayItems = [String]()
    
    var databaseArrayResponse: ShopListingArray! {
        
        didSet {
            print("DEBUG:DATABASE RESPONSE SET")
            guard let safeResponse   = databaseArrayResponse else {return}
            
            if safeResponse.listingArray == [""] {
                for value in searchArray {
                    AuthService.shared.createShopListingArray(key: shopName, value: value)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.fetchDatabaseArray()

                        print("DEBUG:DATABASE RESPONSE  = \(self.searchArray)")
                    }

                }
            }
            else {
                changedIndexValuesFromLoop()
            }
            
            print("DEBUG:DATABASE RESPONSE  = \(safeResponse.listingArray)")

        }
        
    }
    
    
    var networkRequestArrayResponse: ListingsResponse! {
        
        didSet {
            print("DEBUG:DATA RESPONSE SET")

            guard let safeResponse   = networkRequestArrayResponse else {return}
            safeResponse.results.forEach { (result) in
                searchArray.append(result.title)
            }
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
        validateArray {(result) in
            print("DEBUG: CHANGED INDEX = \(result)")
            result.forEach { (value) in
                self.addNewItems(values: value)
            }
            print("DEBUG: COUNT = \(self.databaseArrayResponse.listingArray.count)")

        }
    }
    
    
    // MARK: - Array Validation print("DEBUG: CHANGED INDEX = \(result)")

    
    func addNewItems(values:Int) {
        newArrayItems.append(searchArray[values])
        }
        
    
     
    
    func validateArray(completion:@escaping([Int]) -> Void){
        
        // validates our array and makes sure that its not the same as the previous day.
        // match the database array to the searched array based on index
        // returns the index of changes
        // appends those index arrays to database
        
        var changedIndex         = [Int]() // value of index changes
        guard let safeResponse   = databaseArrayResponse else {return}
        let databaseArray        = safeResponse.listingArray
        let difference           = databaseArray[0..<searchArray.count].difference(from:searchArray).insertions
        // returns an array of values that are different in comparison
        // using 0... allows us to specify from index 0 to the search array max count.
     
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
        UserService.shared.fetchShopListingsArray(name: shopName) {[weak self] (results) in
            guard let self = self else {return}
            self.databaseArrayResponse = results
        }
    }

    
    // MARK: - UI

    func configureUI() {
        view.backgroundColor = .white
    }
}


