//
//  UserService.swift
//  Stock
//
//  Created by TXB4 on 10/09/2020.
//  Copyright © 2020 TobaIbrahim. All rights reserved.
//

import UIKit
import Firebase


struct UserService {
    
    static let shared = UserService()
    let ref           = Database.database().reference()
    
    
    
    
 

//    func fetchStockQuantity(completion: @escaping(StockQuantity,[String]) -> Void) {
//        ref.child("shirts").observeSingleEvent(of: .value) {(snapshot) in
//            guard let dictionary    = snapshot.value as? [String:AnyObject] else {return}
//            let snapshopValue       = snapshot.value as? NSDictionary
//            let value = StockQuantity(dictionary: dictionary)
//            guard let keys  = snapshopValue?.allKeys as? [String] else {return}
////            print(snapshopValue?.allKeys)
//            completion(value, keys)
//
//        }}
    
    
    func fetchShopListingsArray(name:String,completion: @escaping(ShopListingArray) -> Void) {
        ref.child("ShopArray").child(name).child(name).observeSingleEvent(of: .value) {(snapshot) in

            if snapshot.exists() == true {
                guard let snap = snapshot.value as? [String] else {return}
                let value = ShopListingArray(array: snap)
                completion(value)
            }

            else {
                let value = ShopListingArray(array: [""])
                completion(value)
            }

        }

    }
    
    
    func fetchHoldingValuesArray(name:String,completion: @escaping([String]) -> Void) {
        ref.child("ShopArray").child("\(name)").child("HoldingValues").child("HoldingValues").observeSingleEvent(of: .value) {(snapshot) in
            
            if snapshot.exists() == true {
                print("DEBUG: HOLDING VALUE: = TRUE")

                guard let snap = snapshot.value as? [String] else {return}
                completion(snap)
//                print("DEBUG: HOLDING VALUE: = \(snap)")


            }

            else {
                completion([""])
                print("DEBUG: HOLDING VALUE: = NOT AVAILABLE")
            }
        }

    }
    
    
    
    func fetchShopKeysArray(completion: @escaping([String]) -> Void) {
        ref.child("ShopArray").observeSingleEvent(of: .value) {(snapshot) in

            if snapshot.exists() == true {
                let snap            = snapshot.value as? NSDictionary
                guard let values    = snap?.allKeys else {return}
                guard let val       = values as? [String] else {return}
                
                completion(val)
            }

            else {
                completion([""])
            }
        }
    }
    
    
    
    func fetchShopImageUrls(completion: @escaping([String]) -> Void) {
        ref.child("ShopImageUrls").observeSingleEvent(of: .value) {(snapshot) in

            if snapshot.exists() == true {
                let snap            = snapshot.value as? NSDictionary
                guard let values    = snap?.allValues else {return}
                guard let val       = values as? [String] else {return}
                completion(val)
            }

            else {
                completion([""])
            }
        }
    }


//    
//    func setNewData() {
//        let ref = Database.database().reference().child("ShopArray").child("\(key)")
//        var list = [String]()
//        ref.observeSingleEvent(of: .value) { (data) in
//            list = data.value
//            // insert new data at index 0
//            // set data
//            ref.setValue(list)
//        }
//    }

    
    
    
    func updateShirtStockQuantity(Name:String,small:Int,medium:Int,large:Int) {
        
    let values = ["medium":medium,"large":large,"small":small]
        ref.child("shirts").child(Name).setValue(values)
    }
    
    func updateAccessoryStockQuantity(Name:String,value:Int) {
        ref.child("shirts").child(Name).setValue(value)
    }
        
    }
    
    



