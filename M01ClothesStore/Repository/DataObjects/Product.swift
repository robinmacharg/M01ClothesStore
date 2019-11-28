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

struct Product: Codable {
    enum CodingKeys: String, CodingKey {
        case id = "productId"
        case name
        case category
        case price
        case stock
    }
    
    var id: Int;
    var name: String;
    var category: String;
    var price: Double;
    var stock: Int;
}
