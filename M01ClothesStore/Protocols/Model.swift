//
//  ModelProtocol.swift
//  M01ClothesStore
//
//  Created by Robin Macharg on 28/11/2019.
//  Copyright © 2019 MachargCorp. All rights reserved.
//

import Foundation

enum Store {
    case catalogue
    case wishlist
    case cart
}

protocol Model {
    func create(_ product: Product, in: Store, _ completion: (() -> ())?)
    func remove(at: Int, from: Store, _ completion: (() -> ())?)
    func remove(id: Int, from: Store, _ completion: (() -> ())?)
    func update(product: Product, in: Store, _ completion: (() -> ())?)
    func delete(product: Product, from: Store, _ completion: (() -> ())?)
    
    func count(of: Store) -> Int
    
    func get(itemWithId: Int, from: Store) -> Product?
    func get(itemAtIndex: Int, from: Store) -> Product?
    
    
    
//    func toggleWishlistInclusion(productId: Int, _ completion: (() -> ())?)
//    func removeFromWishlist(productId: Int, _ completion: (() -> ())?)
//    func moveFromWishlistToCart(productId: Int, _ completion: (() -> ())?)
//    func itemWithID(id: Int, in: Store) -> Product?
//    func setStockLevel(for id: Int,  _ completion: (() -> ())?)
}
