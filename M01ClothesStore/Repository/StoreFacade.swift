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
    
    // Private
    
    private var initialised: Bool = false
    private var api: API? = nil
    private var model: Model? = nil
    
    // Public
//    var cart: [Product] = []
    var wishlist: [Int:Product] = [:] // ID:Product
    
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
    
//    var orderedCatalogueKeys: [Int] {
//        get {
//            return catalogue.keys.sorted()
//        }
//    }
    
//    var cartTotal: Double {
//        get { return cart.reduce(0) { (result, product) -> Double in
//            return result + product.price
//        }}
//    }
}

// MARK: - API/Model Facade

extension StoreFacade {
    
    var catalogueProductCount: Int { return model?.count(of: .catalogue) ?? 0 }
    var wishlistCount: Int { return model?.count(of: .wishlist) ?? 0 }
    var cartCount: Int { return model?.count(of: .cart) ?? 0 }
    
    // MARK: - General
    
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
    
    
    
    
    // MARK: - Cart
    
    func removeProductFromCart(index: Int, _ completion: (() -> ())? = nil) {
        if let cartProduct = model?.get(itemAtIndex: index, from: .cart),
            var catalogueProduct = self.model?.get(itemWithId: cartProduct.id, from: .catalogue) {
            api?.DELETEFromCart { (response) in
                self.model?.delete(product: cartProduct, from: .cart, nil)
                catalogueProduct.stock += 1
                self.model?.update(product: catalogueProduct, in: .catalogue, nil)
                completion?()
            }
        }
    }
    
//    func catalogueItemWithID(id: Int) -> Product? {
//        return model?.itemWithID(id: id)
//    }
//
//    func item(at i: Int, in store: Store) -> Product? {
//        var products: [Product] = []
//        switch store {
//        case .catalogue:
//            products = model?.catalogue ?? []
//        case .wishlist:
//            break
//        case .cart:
//            break
//        }
//        return products[i]
//    }
//
//    func item(withId id: Int, in store: Store) -> Product? {
//        switch store {
//        case .catalogue:
//            return model?.itemWithID(id: id)
//        case .wishlist:
//            break
//        case .cart:
//            break
//        }
//
//        return nil
//    }
//
//    func addProduct(product: Product, to store: Store, _ completion: (() -> ())? = nil) {
//        switch store {
//        case .catalogue:
//            break
//        case .cart:
//            api?.POSTToCart(productId: product.id) { response in
//                self.model?.setStockLevel(for: product.id, nil)
//                self.model?.addProductToCart(productID: product.id, nil)
//            }
//            completion?()
//        case .wishlist:
//            break
//        }
//
//
//    }

    
    

}

// MARK: - <API>

extension StoreFacade {
//    func GETProducts(completion: @escaping ([Product]) -> ()) {
//
//    }
//
//    var APIroot: String? {
//        get {
//            return ""
//        }
//        set {
//
//        }
//    }
    



    /**
     POST the addition of a product to the shopping cart
     */
    
//    func POSTToCart(productId: Int, completion: @escaping (HTTPURLResponse) -> ()) {
//        assertInitialized()
//
//        let url = URL(string: "\(APIroot!)/cart")!
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "content-type")
//        let cartItem = CartItem(productId: productId, count: 0)
//        let cartItemJSON = try! encoder.encode(cartItem)
//        request.httpBody = cartItemJSON
//
//        let dataTask = session.dataTask(with: request) { _ , response, error in
//            if let error = error {
//                print("DataTask error: \(error.localizedDescription)")
//            }
//            else if
//                let response = response as? HTTPURLResponse,
//                response.statusCode == 201
//            {
//                DispatchQueue.main.async {
//                    completion(response)
//                }
//            }
//
//        }
//        dataTask.resume()
//    }

//    func DELETEFromCart(completion: @escaping (HTTPURLResponse) -> ()) {
//        assertInitialized()
//
//        let url = URL(string: "\(APIroot!)/cart/1")! // TODO: store cart# from POST requests?
//        var request = URLRequest(url: url)
//        request.httpMethod = "DELETE"
//
//        let dataTask = session.dataTask(with: request) { _ , response, error in
//            if let error = error {
//                print("DataTask error: \(error.localizedDescription)")
//            }
//            else if
//                let response = response as? HTTPURLResponse,
//                response.statusCode == 204
//            {
//                DispatchQueue.main.async {
//                    completion(response)
//                }
//            }
//        }
//        dataTask.resume()
//    }
}

// MARK: - <Model>
//
// Data Access convenience functions

//extension Repository: Model {
//    func addProductToCatalogue(product: Product, _ completion: (() -> ())?) {
//
//    }
//
//    func addProductToCart(productID: Int, _ completion: (() -> ())? = nil) {
//        POSTToCart(productId: productID) { response in
//            if let product = self.catalogue[productID], product.stock > 0 {
//                self.catalogue[productID]!.stock -= 1
//                self.cart.append(product)
//            }
//            completion?()
//        }
//    }
//
//    func removeProductFromCart(index: Int, _ completion: (() -> ())? = nil) {
//        DELETEFromCart { response in
//            if self.catalogue[self.cart[index].id] != nil {
//                self.catalogue[self.cart[index].id]?.stock += 1
//            }
//            self.cart.remove(at: index)
//
//            completion?()
//        }
//    }
//
//    func toggleWishlistInclusion(productId: Int, _ completion: (() -> ())? = nil) {
//        if wishlist.keys.contains(productId) {
//            wishlist.removeValue(forKey: productId)
//        }
//        else {
//            wishlist[productId] = catalogue[productId]
//        }
//
//        completion?()
//    }
//
//    func removeFromWishlist(productId: Int, _ completion: (() -> ())? = nil) {
//        if wishlist.keys.contains(productId) {
//            wishlist.removeValue(forKey: productId)
//        }
//
//        completion?()
//    }
//
//    func moveFromWishlistToCart(productId: Int, _ completion: (() -> ())? = nil) {
//        if wishlist.keys.contains(productId) {
//            removeFromWishlist(productId: productId)
//            addProductToCart(productID: productId)
//        }
//
//        completion?()
//    }
//}
