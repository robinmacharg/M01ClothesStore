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
    var catalogueProducts: [Product] { get }
    func addProductToCatalogue(_ product: Product, _ completion: (() -> ())?)
    func addProductToCart(productID: Int, _ completion: (() -> ())?)
    func removeProductFromCart(index: Int, _ completion: (() -> ())?)
    func toggleWishlistInclusion(productId: Int, _ completion: (() -> ())?)
    func removeFromWishlist(productId: Int, _ completion: (() -> ())?)
    func moveFromWishlistToCart(productId: Int, _ completion: (() -> ())?)
    func catalogueItemWithID(id: Int) -> Product
}
