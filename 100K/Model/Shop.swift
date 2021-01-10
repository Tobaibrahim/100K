//
//  Shop.swift
//  PostNetworkTests
//
//  Created by TXB4 on 07/03/2020.
//  Copyright © 2020 TXB4. All rights reserved.
//

import UIKit

struct ShopResponse: Codable {
    
    let count: Int
    let results: [Shop]
    
}


struct Shop:Codable {
    
    var title:String
    var currencyCode:String
    var listingActiveCount:Int
    var loginName:String
    var numFavorers:Int
    var iconUrlFullxfull:String
    var ImageUrl760X100:String?
}
    



