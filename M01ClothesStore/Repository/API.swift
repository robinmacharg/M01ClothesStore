//
//  API.swift
//  M01ClothesStore
//
//  Created by Robin Macharg on 28/11/2019.
//  Copyright © 2019 MachargCorp. All rights reserved.
//

import Foundation

class API: APIProtocol {
    
    private var root: String
    private let session:  URLSession
    private var dataTask: URLSessionDataTask?
    
    init(root: String) {
        self.root = root
        self.session = URLSession(configuration: .default)
    }
    
    // GET https://<ROOT>/products
    
    func GETProducts(completion: @escaping () -> ()) {
        
        let url = URL(string: "\(root)/products")
        
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
                DispatchQueue.main.async {
                    completion(response)
                }
            }
        }
        dataTask?.resume()
    }
    
    func GETProductDetails() {
            
    }
    
    func POSTToCart(product: Product) {
        
    }
    
    func DELETEFromCart(product: Product) {
        
    }
    
    
}
