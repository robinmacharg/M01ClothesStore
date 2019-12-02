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
    private init() {
        self.session = URLSession(configuration: .default)
        self.decoder = JSONDecoder()
        self.encoder = JSONEncoder()
    }
    
    // MARK: - Properties
    
    // Private
    
    private let session:  URLSession
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    // Public

    var APIroot: String?
    
    var Catalogue: [Int:Product] = [:]
    var Cart: [Product] = []
    
    var dirtyCatalogue: Bool = false;
//    var dirtyCart: Bool = false; // TODO: remove or implement
    
    // MARK: - Utility
    
    func assertInitialized() {
        assert(APIroot != nil)
    }
    
    var orderedCatalogueKeys: [Int] {
        get {
            return Catalogue.keys.sorted()
        }
    }
    
    var cartTotal: Double {
        get { return Cart.reduce(0) { (result, product) -> Double in
            return result + product.price
        }}
    }
}

// MARK: - <API>

extension Repository: API {

    /**
     GET, parse and store a list of products from the server
     */
    func GETProducts(completion: @escaping (HTTPURLResponse) -> ()) {
        assertInitialized()
        
        let url = URL(string: "\(APIroot!)/products")
        
        let dataTask = session.dataTask(with: url!) { [weak self] data, response, error in
            if let error = error {
                print("DataTask error: \(error.localizedDescription)")
            }
            else if
                let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200
            {
                // Parse response
                let catalogue = try! Repository.shared.decoder.decode(CatalogueResponse.self, from: data)
                
                for product in catalogue {
                    Repository.shared.Catalogue[product.id] = product
                }

                // Call the completion handler
                DispatchQueue.main.async {
                    completion(response)
                }
            }
        }
        dataTask.resume()
    }

//    func GETProductDetails() {
//        
//    }
//
    /**
     POST the addition of a product to the shopping cart
     */
    
    func POSTToCart(productId: Int, completion: @escaping (HTTPURLResponse) -> ()) {
        assertInitialized()
        
        let url = URL(string: "\(APIroot!)/cart")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        let cartItem = CartItem(productId: productId)
        let cartItemJSON = try! encoder.encode(cartItem)
        request.httpBody = cartItemJSON
        
        let dataTask = session.dataTask(with: request) {[weak self] data, response, error in
            if let error = error {
                print("DataTask error: \(error.localizedDescription)")
            }
            else if
                let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 201
            {
                DispatchQueue.main.async {
                    completion(response)
                }
            }
            
        }
        dataTask.resume()
    }

    func DELETEFromCart(completion: @escaping (HTTPURLResponse) -> ()) {
        assertInitialized()
        
        let url = URL(string: "\(APIroot!)/cart/1")! // TODO: store cart# from POST requests?
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let dataTask = session.dataTask(with: request) {[weak self] data, response, error in
            if let error = error {
                print("DataTask error: \(error.localizedDescription)")
            }
            else if
                let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 204
            {
                DispatchQueue.main.async {
                    completion(response)
                }
            }
        }
        dataTask.resume()
    }
}

// MARK: - <Model>
//
// Data Access convenience functions

extension Repository: Model {
    func addProductToCart(productID: Int, _ completion: (() -> ())? = nil) {
        POSTToCart(productId: productID) { response in
            if let product = self.Catalogue[productID] {
                self.Catalogue[productID]!.stock -= 1
                self.Cart.append(product)
                
                Repository.shared.dirtyCatalogue = true
                Repository.shared.dirtyCart = true
            }
            completion?()
        }
    }
    
    func removeProductFromCart(index: Int, _ completion: (() -> ())? = nil) {
        DELETEFromCart { response in
            if self.Catalogue[self.Cart[index].id] != nil {
                self.Catalogue[self.Cart[index].id]?.stock += 1
                Repository.shared.dirtyCatalogue = true
            }
            self.Cart.remove(at: index)

            Repository.shared.dirtyCart = true

            completion?()
        }
    }
}
