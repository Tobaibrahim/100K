//
//  AvatarImage.swift
//  PostNetworkTests
//
//  Created by TXB4 on 01/05/2020.
//  Copyright © 2020 TXB4. All rights reserved.
//

import Foundation


struct AvatarImageResponse: Codable {
    
    let count: Int
    let results: [AvatarImage]
    
}


struct AvatarImage:Codable {
    
    var src: String?
}

