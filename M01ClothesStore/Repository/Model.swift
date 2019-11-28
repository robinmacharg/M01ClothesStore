//
//  Model.swift
//  M01ClothesStore
//
//  Created by Robin Macharg on 28/11/2019.
//  Copyright © 2019 MachargCorp. All rights reserved.
//

import Foundation

class Model: ModelProtocol {
    
    var Catalogue: [Product] = []
    var Wishlist: [Product] = []
    var Cart: [Product : Int] = [:]
    
    private struct Products: Codable {
        var products: [Product]
    }
    
    
    func parseProducts(products: String, completion: () -> ()) {
        
        
        
        completion()
    }
}
