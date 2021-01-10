//
//  Listings.swift
//  PostNetworkTests
//
//  Created by TXB4 on 11/03/2020.
//  Copyright © 2020 TXB4. All rights reserved.
//

import Foundation


struct ListingsResponse: Codable {
    
    let count: Int
    let results: [Listings]

}
struct Listings: Codable {
    
    var title:String
    var price:String
    var currencyCode:String
    var quantity: Int
    var listingId:Int?
    var views:Int?
    var url:String?

}

    
        
    
    



    
 

        
    


