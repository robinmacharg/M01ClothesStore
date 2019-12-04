//
//  ClothesStoreModel.swift
//  M01ClothesStore
//
//  Created by Robin Macharg on 04/12/2019.
//  Copyright © 2019 MachargCorp. All rights reserved.
//

import Foundation

class ClothesStoreModel: Model {
    
    private var catalogue: [Int:Product] = [:] // ID:Product
    private var cart: [Product] = []
    private var wishlist: [Int:Product] = [:] // ID:Product

    var orderedCatalogueKeys: [Int] {
        get {
            return catalogue.keys.sorted()
        }
    }

    var catalogueProducts: [Product] { Array(catalogue.values) }
    
    func catalogueItemWithID(id: Int) -> Product? {
        
    }
    
    func addProductToCatalogue(_ product: Product, _ completion: (() -> ())? = nil) {
        catalogue[product.id] = product
    }
    
    func addProductToCart(productID: Int, _ completion: (() -> ())? = nil) {
        
    }
    
    func removeProductFromCart(index: Int, _ completion: (() -> ())? = nil) {
        if catalogue[cart[index].id] != nil {
            catalogue[cart[index].id]?.stock += 1
        }
        cart.remove(at: index)

        completion?()
    }
    
    func toggleWishlistInclusion(productId: Int, _ completion: (() -> ())? = nil) {
        
    }
    
    func removeFromWishlist(productId: Int, _ completion: (() -> ())? = nil) {
        
    }
    
    func moveFromWishlistToCart(productId: Int, _ completion: (() -> ())? = nil) {
        
    }
}
