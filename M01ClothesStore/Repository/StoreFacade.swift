//
//  Repository.swift
//  M01ClothesStore
//
//  Created by Robin Macharg on 28/11/2019.
//  Copyright © 2019 MachargCorp. All rights reserved.
//

import Foundation

/**
 A Singleton data access respository.
 */

public class StoreFacade {

    // MARK: - Singleton
    
    static let shared = StoreFacade()
    private init() {}
    
    // MARK: - Properties
    
    private var initialised: Bool = false
    private var api: API? = nil
    private var model: Model? = nil
    
    // MARK: - Initialisation

    static func initalise(root: String, api: API, model: Model) {
        StoreFacade.shared.api = api
        StoreFacade.shared.model = model
        StoreFacade.shared.api?.APIroot = root
        StoreFacade.shared.initialised = true
    }

    // MARK: - Utility
    
    private func assertInitialized() {
        assert(initialised)
    }
}

// MARK: - API/Model Facade

extension StoreFacade {
    
    // MARK: - General
    
    func count(of store: Store) -> Int {
        return model?.count(of: store) ?? 0
    }
    
    func get(itemAtIndex index: Int, from store: Store) -> Product? {
        return model?.get(itemAtIndex: index, from: store)
    }

    func get(itemWithId id: Int, from store: Store) -> Product? {
        return model?.get(itemWithId: id, from: store)
    }
    
    // MARK: - Catalogue
    
    func loadCatalogue(_ completion: (() -> ())? = nil) {
        assertInitialized()
        
        api?.GETProducts(completion: { products in
            for product in products {
                self.model?.create(product, in: .catalogue, nil)
            }
            completion?()
        })
    }
    
    func addProductToCart(id: Int, _ completion: (() -> ())? = nil) {
        assertInitialized()
        
        if var product = model?.get(itemWithId: id, from: .catalogue), product.stock > 0 {
            
            // Update stock values immediately
            product.stock -= 1
            self.model?.update(product: product, in: .catalogue, nil)
            
            api?.POSTToCart(productId: id, completion: { (response) in
                self.model?.create(product, in: .cart, nil)
                
                completion?()
            })
        }
    }
    
    func toggleWishlistInclusion(id: Int, _ completion: (() -> ())? = nil) {
        assertInitialized()
        
        // Remove
        if model?.get(itemWithId: id, from: .wishlist) != nil {
            model?.remove(id: id, from: .wishlist, nil)
        }
            
        // Add
        else {
            if let product = model?.get(itemWithId: id, from: .catalogue) {
                model?.create(product, in: .wishlist, nil)
            }
        }
        completion?()
    }
    
    // MARK: - Wishlist
    
    func removeFromWishlist(id: Int, _ completion: (() -> ())? = nil) {
        assertInitialized()
        
        if model?.get(itemWithId: id, from: .wishlist) != nil {
            model?.remove(id: id, from: .wishlist, nil)
        }
        completion?()
    }
    
    func moveFromWishlistToCart(id: Int, _ completion: (() -> ())? = nil) {
        assertInitialized()
        
        if let product = model?.get(itemWithId: id, from: .wishlist) {
            api?.POSTToCart(productId: id) { (response) in
                self.model?.remove(id: id, from: .wishlist, nil)
                self.model?.create(product, in: .cart, nil)
                
                if var product = self.model?.get(itemWithId: id, from: .catalogue), product.stock > 0 {
                    product.stock -= 1
                    self.model?.update(product: product, in: .catalogue, nil)
                }
                completion?()
            }
        }
    }
    
    // MARK: - Cart
    
    func removeProductFromCart(index: Int, _ completion: (() -> ())? = nil) {
        assertInitialized()
        
        if let cartProduct = model?.get(itemAtIndex: index, from: .cart),
            var catalogueProduct = self.model?.get(itemWithId: cartProduct.id, from: .catalogue) {
            api?.DELETEFromCart { (response) in
                self.model?.remove(at: index, from: .cart, nil)
                catalogueProduct.stock += 1
                self.model?.update(product: catalogueProduct, in: .catalogue, nil)
                completion?()
            }
        }
    }
    
    func isInStock(_ product: Product) -> Bool {
        if let product = StoreFacade.shared.get(itemWithId: product.id, from: .catalogue), product.stock > 0 {
            return true
        }
        return false
    }
    
    var cartTotal: Double {
        return model?.cartTotal ?? 0.0
    }
    
    // MARK: - Change Subscriptions
    
    func subscribeForModelChanges(_ changeHandler: (() -> ())?) {
        model?.subscribeForChanges(changeHandler)
    }
    
    
}
