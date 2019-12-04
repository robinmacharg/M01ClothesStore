//
//  ClothesStoreAPI.swift
//  M01ClothesStore
//
//  Created by Robin Macharg on 04/12/2019.
//  Copyright © 2019 MachargCorp. All rights reserved.
//

import Foundation

class ClothesStoreAPI: API {
    
    private let session: URLSession
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    
    var APIroot: String?
    
    init() {
        self.session = URLSession(configuration: .default)
        self.decoder = JSONDecoder()
        self.encoder = JSONEncoder()
    }
    
    func GETProducts(completion: @escaping ([Product]) -> ()) {
        let url = URL(string: "\(APIroot!)/products")
        
        let dataTask = session.dataTask(with: url!) { data, response, error in
            if let error = error {
                print("DataTask error: \(error.localizedDescription)")
            }
            else if
                let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200
            {
                // Parse response
                let catalogue = try! self.decoder.decode([Product].self, from: data)
                
//                for product in catalogue {
//                    Repository.shared.catalogue[product.id] = product
//                }

                // Call the completion handler
                DispatchQueue.main.async {
                    completion(catalogue)
                }
            }
        }
        dataTask.resume()
    }
    
    func POSTToCart(productId: Int, completion: @escaping (HTTPURLResponse) -> ()) {
        
    }
    
    func DELETEFromCart(completion: @escaping (HTTPURLResponse) -> ()) {
        
    }
}
