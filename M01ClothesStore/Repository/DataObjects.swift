//
//  Product.swift
//  M01ClothesStore
//
//  Created by Robin Macharg on 28/11/2019.
//  Copyright © 2019 MachargCorp. All rights reserved.
//

import Foundation

/**
 Represents a product that can be bought
 */

struct Product: Codable, Hashable {
    var id: Int;
    var name: String;
    var category: String;
    var price: Double;
    var stock: Int;
    
    // MARK: - <Codable>
    
    enum CodingKeys: String, CodingKey {
        case id = "productId"
        case name
        case category
        case price
        case stock
    }
    
    // MARK: - <Hashable>
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

typealias CatalogueResponse = [Product]

// A shopping cart item to be POSTED to the API
struct CartItem: Codable {
    var productId: Int;
    var count: Int = 0;
    
    // MARK: - <Codable>
    // We only want to POST the product ID
    enum CodingKeys: CodingKey {
        case productId
    }
}
