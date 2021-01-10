//
//  NetworkManager.swift
//  100K
//
//  Created by TXB4 on 06/01/2021.
//

import UIKit


class NetworkManager {
    
    static let shared     = NetworkManager()
    var scrapedString     = String()
    
    let cache             = NSCache<NSString,UIImage>()
    private let baseURL   = "https://openapi.etsy.com/v2/"
    private var key       = "ej72ztgt3p04ddxrbuil4ixz" // secure in refactoring
    
    
    private init () {}
    
    
    func getListings (for user:String,completed:@escaping(Result<ListingsResponse,CustomErrors>) -> Void) {
        
        let endpoint = baseURL + "shops/\(user)/listings/active?api_key=\(key)&limit=500"
        
        
        //   print(endpoint)
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data,response,error in
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidDataResponse))
                
                return
            }
            
            do {
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                print(data)
                
                let listings  = try decoder.decode(ListingsResponse.self, from: data)
                completed(.success(listings))
                
                
            }
            
            catch {
                
                completed(.failure(.invalidDataResponse))
                print(error)
            }
        }
        
        task.resume()
    }
    
    
    
    
    func getListingShop (for listingId:String,completed:@escaping(Result<ShopResponse,CustomErrors>) -> Void) {
        
        let endpoint = baseURL + "shops/listing/\(listingId)?api_key=\(key)"
        
        
        //    print(endpoint)
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) {data,response,error in
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
                
            }
            
            guard let data = data else {
                completed(.failure(.invalidDataResponse))
                return
            }
            
            do {
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let shop  = try decoder.decode(ShopResponse.self, from: data)
                
                completed(.success(shop))
                print(response.statusCode)
                
            }
            
            catch {
                
                completed(.failure(.invalidDataResponse))
                print(error)
                print(data)
            }
        }
        
        task.resume()
    }
    
    
    func searchShop (for searchShopName:String,pagination:String,completed:@escaping(Result<SearchedShopResponse,CustomErrors>) -> Void) {
        
        //            https://openapi.etsy.com/v2/shops?method=GET&api_key=4h5gewvp7n7xrmueku6jbmom&shop_name=amazing&limit=10
        
        let endpoint = baseURL + "shops?method=GET&api_key=\(key)&shop_name=\(searchShopName)&limit=\(pagination)"
        
        print("DEBUG: SHOP ENDPOINT = \(endpoint)")
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) {data,response,error in
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
                
            }
            
            guard let data = data else {
                completed(.failure(.invalidDataResponse))
                return
            }
            
            do {
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let shop  = try decoder.decode(SearchedShopResponse.self, from: data)
                
                completed(.success(shop))
                print(response.statusCode)
                
            }
            
            catch {
                
                completed(.failure(.invalidDataResponse))
            }
        }
        
        task.resume()
        
        
        
        
        
        
        func getAvatarImage (for shop:String,completed:@escaping(Result<AvatarImageResponse,CustomErrors>) -> Void) {
            
            let endpoint = baseURL + "users/\(shop)/avatar/src?api_key=\(key)"
            
            //        /users/:user_id/avatar/src
            
            
            guard let url = URL(string: endpoint) else {
                completed(.failure(.invalidURL))
                return
            }
            
            let task = URLSession.shared.dataTask(with: url) {data,response,error in
                if let _ = error {
                    completed(.failure(.unableToComplete))
                    return
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    completed(.failure(.invalidResponse))
                    return
                    
                }
                
                guard let data = data else {
                    completed(.failure(.invalidDataResponse))
                    return
                }
                
                do {
                    
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    let avatarImage  = try decoder.decode(AvatarImageResponse.self, from: data)
                    
                    completed(.success(avatarImage))
                    print(response.statusCode)
                    
                }
                
                catch {
                    
                    completed(.failure(.invalidDataResponse))
                    print(error)
                    //              print(data)
                }
            }
            
            task.resume()
        }
        
        
        
        
        
    }
    
    
    
}
