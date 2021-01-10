//
//  SearchedShop.swift
//  PostNetworkTests
//
//  Created by TXB4 on 27/06/2020.
//  Copyright © 2020 TXB4. All rights reserved.
//

import UIKit



struct SearchedShopResponse: Codable {
    
    let count: Int
    let results: [SearchedShopResult]
    
}


struct SearchedShopResult:Codable {
    
    var shopName:String
    var iconUrlFullxfull:String?
    
    
}


