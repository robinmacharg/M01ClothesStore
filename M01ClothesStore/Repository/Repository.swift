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
    private var dataTask: URLSessionDataTask?

    // Public

    var APIroot: String?
    
    var Catalogue: [Product]? = []

    // MARK: - Utility
    
    func assertInitialized() {
        assert(APIroot != nil)
    }
}

// MARK: - <APIProtocol>

extension Repository: API {

    /**
     Get, parse and store a list of products from the server
     */
    func GETProducts(completion: @escaping (HTTPURLResponse) -> ()) {
        assertInitialized()
        
        let url = URL(string: "\(APIroot!)/products")
        
        dataTask = session.dataTask(with: url!) { [weak self] data, response, error in
            defer {
                self?.dataTask = nil
            }
            if let error = error {
                print("DataTask error: \(error.localizedDescription)")
            }
            else if
                let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200
            {
                // Parse response
                Repository.shared.Catalogue = try! Repository.shared.decoder.decode(CatalogueResponse.self, from: data)

                // Call the completion handler
                DispatchQueue.main.async {
                    completion(response)
                }
            }
        }
        dataTask?.resume()
    }

//    func GETProductDetails() {
//        
//    }
//
//    func POSTToCart(product: Product) {
//        
//    }
//
//    func DELETEFromCart(product: Product) {
//        
//    }
}

// MARK: - <ModelProtocol>


extension Repository: Model {
}
