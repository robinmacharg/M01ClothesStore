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
    
    /**
     GET, parse and store a list of products from the server
     */
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

                // Call the completion handler
                DispatchQueue.main.async {
                    completion(catalogue)
                }
            }
        }
        dataTask.resume()
    }
    
    // Unused at present, not required for this exercise
    //    func GETProductDetails() {}
    
    func POSTToCart(productId: Int, completion: @escaping (HTTPURLResponse) -> ()) {
        let url = URL(string: "\(APIroot!)/cart")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        let cartItem = CartItem(productId: productId, count: 0)
        let cartItemJSON = try! encoder.encode(cartItem)
        request.httpBody = cartItemJSON

        let dataTask = session.dataTask(with: request) { _ , response, error in
            if let error = error {
                print("DataTask error: \(error.localizedDescription)")
            }
            else if
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
        let url = URL(string: "\(APIroot!)/cart/1")! // TODO: store cart# from POST requests?
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        let dataTask = session.dataTask(with: request) { _ , response, error in
            if let error = error {
                print("DataTask error: \(error.localizedDescription)")
            }
            else if
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
