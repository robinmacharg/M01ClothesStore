//
//  ClothesStoreModel.swift
//  M01ClothesStore
//
//  Created by Robin Macharg on 04/12/2019.
//  Copyright © 2019 MachargCorp. All rights reserved.
//

import Foundation

class ClothesStoreModel: Model {
    
    // MARK: - Stores
    
    private var catalogue: [Int:Product] = [:] // ID:Product
    private var wishlist: [Int:Product] = [:] // ID:Product
    private var cart: [Product] = []
    
    // MARK: - CRUD operations
    
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
    
    func update(product: Product, in store: Store, _ completion: (() -> ())? = nil) {
        switch store {
        case .catalogue:
            catalogue[product.id] = product
        default:
            fatalError("Can't update items in: \(store)")
        }
    }

    func remove(at index: Int, from store: Store, _ completion: (() -> ())? = nil) {
        switch store {
        case .cart:
            cart.remove(at: index)
            
        default:
            fatalError("Not implemented for: \(store)")
        }
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
    
    // MARK: - Other operations
    
    func count(of store: Store) -> Int {
        switch store {
        case .catalogue: return catalogue.count
        case .wishlist: return wishlist.count
        case .cart: return cart.count
        }
    }
    
    // It's simpler to expose this directly from the model than iterate over the cart
    // with the model primative methods
    var cartTotal: Double {
        get { return cart.reduce(0) { (result, product) -> Double in
            return result + product.price
        }}
    }
}
