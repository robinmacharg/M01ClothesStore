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
 TODO: Provide injection-configurable backend web API access and local Model data access.
 */

public class Repository {

    // MARK: - Singleton
    
    static let shared = Repository()
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
        Repository.shared.api = api
        Repository.shared.model = model
        Repository.shared.api?.APIroot = root
        Repository.shared.initialised = true
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
    
    var cartTotal: Double {
        get { return cart.reduce(0) { (result, product) -> Double in
            return result + product.price
        }}
    }
}

// MARK: - API/Model Facade

extension Repository {
    
    var catalogueProductCount: Int { return model?.catalogue.count ?? 0 }
    var wishlistCount: Int { return model?.wishlist.count ?? 0 }
    var cartCount: Int { return model?.cart.count ?? 0 }
    
    func loadCatalogue(_ completion: (() -> ())? = nil) {
        assertInitialized()
        
        api?.GETProducts(completion: { products in
            for product in products {
                self.model?.addProductToCatalogue(product, nil)
            }
            completion?()
        })
    }
    
    func removeProductFromCart(index: Int, _ completion: (() -> ())? = nil) {
        api?.DELETEFromCart(completion: { (response) in
            self.model?.removeProductFromCart(index: index) {
               completion?()
            }
        })
    }
    
    func catalogueItemWithID(id: Int) -> Product? {
        return model?.catalogueItemWithID(id: id)
    }
    
    func item(at i: Int, in store: Store) -> Product? {
        var products: [Product] = []
        switch store {
        case .catalogue:
            products = model?.catalogue ?? []
        case .wishlist:
            break
        case .cart:
            break
        }
        return products[i]
    }
    
    func item(withId id: Int, in store: Store) -> Product? {
        switch store {
        case .catalogue:
            return model?.catalogueItemWithID(id: id)
        case .wishlist:
            break
        case .cart:
            break
        }

        return nil
    }
    
    func addProduct(product: Product, to store: Store, _ completion: (() -> ())? = nil) {
        switch store {
        case .catalogue:
            break
        case .cart:
            api?.POSTToCart(productId: product.id) { response in
                self.model?.reduceStockLevel(for: product.id, nil)
                self.model?.addProductToCart(productID: product.id, nil)
            }
            completion?()
        case .wishlist:
            break
        }
        
        
    }

    
    

}

// MARK: - <API>

extension Repository: API {
    func GETProducts(completion: @escaping ([Product]) -> ()) {
        
    }
    
    var APIroot: String? {
        get {
            return ""
        }
        set {
            
        }
    }
    



    /**
     POST the addition of a product to the shopping cart
     */
    
    func POSTToCart(productId: Int, completion: @escaping (HTTPURLResponse) -> ()) {
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
    }

    func DELETEFromCart(completion: @escaping (HTTPURLResponse) -> ()) {
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
    }
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
