//
//  Protocols.swift
//  100K
//
//  Created by TXB4 on 14/01/2021.
//

import Foundation


protocol ShopSelectionDelegate:class {
    func didAddShop(shopName:String)
}


protocol UpdateShopData:class {
    func didAddShopData(shopName:String)
}
