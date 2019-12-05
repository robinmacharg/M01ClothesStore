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
    private var wishlist: [Int:Product] = [:] // ID:Product
    private var cart: [Product] = []
    
    func count(of store: Store) -> Int {
        switch store {
        case .catalogue: return catalogue.count
        case .wishlist: return wishlist.count
        case .cart: return cart.count
        }
    }
    
    func create(_ product: Product, in store: Store, _ completion: (() -> ())? = nil) {
        switch store {
        case .catalogue:
            catalogue[product.id] = product
        
        case .wishlist:
            wishlist[product.id] = product

        case .cart:
            cart.append(product)
        }
    }
    
    func remove(at: Int, from store: Store, _ completion: (() -> ())? = nil) {
        
    }
    
    func remove(id: Int, from store: Store, _ completion: (() -> ())? = nil) {
        switch store {
        case .catalogue:
            catalogue.removeValue(forKey: id)
        
        case .wishlist:
            wishlist.removeValue(forKey: id)

        default:
            fatalError("Can't remove items in: \(store) by key")
        }
    }
    
    func update(product: Product, in store: Store, _ completion: (() -> ())? = nil) {
        switch store {
        case .catalogue:
            catalogue[product.id] = product
        default:
            fatalError("Can't update items in: \(store)")
        }
    }
    
    func delete(product: Product, from: Store, _ completion: (() -> ())? = nil) {
        
    }
    
    func get(itemWithId id: Int, from store: Store) -> Product? {
        switch store {
        case .catalogue:
            return catalogue[id]
        case .wishlist:
            return wishlist[id]
        default:
            fatalError("Can't retreive items in: \(store) by ID")
        }
    }
    
    func get(itemAtIndex index: Int, from store: Store) -> Product? {
        switch store {
        case .catalogue:
            // Impose ID-ordering on the catalogue
            if index < catalogue.count {
                return catalogue[catalogue.keys.sorted()[index]]
            }
        case .wishlist:
            // Impose ID-ordering on the catalogue
            if index < wishlist.count {
                return wishlist[wishlist.keys.sorted()[index]]
            }
        case .cart:
            // Just an array
            if index < cart.count {
                return cart[index]
            }
        }
        
        // Fall-through default
        return nil
    }
    


//    var orderedCatalogueKeys: [Int] {
//        get {
//            return catalogue.keys.sorted()
//        }
//    }
//
//    var catalogue: [Product] { return Array(catalogue.values) }
//
//    func catalogueItemWithID(id: Int) -> Product? {
//        return catalogue[id]
//    }
//
//    func addProductToCatalogue(_ product: Product, _ completion: (() -> ())? = nil) {
//        catalogue[product.id] = product
//    }
//
//    func addProductToCart(productID id: Int, _ completion: (() -> ())? = nil) {
//        if let product = catalogueItemWithID(id: id) {
//            cart.append(product)
//        }
//    }
//
//    func removeProductFromCart(index: Int, _ completion: (() -> ())? = nil) {
//        if catalogue[cart[index].id] != nil {
//            catalogue[cart[index].id]?.stock += 1
//        }
//        cart.remove(at: index)
//
//        completion?()
//    }
//
//    func toggleWishlistInclusion(productId: Int, _ completion: (() -> ())? = nil) {
//
//    }
//
//    func removeFromWishlist(productId: Int, _ completion: (() -> ())? = nil) {
//
//    }
//
//    func moveFromWishlistToCart(productId: Int, _ completion: (() -> ())? = nil) {
//
//    }
//
//    func reduceStockLevel(for id: Int,  _ completion: (() -> ())? = nil) {
//        var product = catalogueItemWithID(id: id)
//        product?.stock -= 1
//        catalogue[id] = product
//    }
}
