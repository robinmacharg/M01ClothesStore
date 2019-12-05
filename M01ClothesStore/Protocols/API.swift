//
//  APIProtocol.swift
//  M01ClothesStore
//
//  Created by Robin Macharg on 28/11/2019.
//  Copyright © 2019 MachargCorp. All rights reserved.
//

import Foundation

protocol API {
    var APIroot: String? { get set }
    
    func GETProducts(completion: @escaping (_ products: [Product]) -> ());
    func POSTToCart(productId: Int, completion: @escaping (HTTPURLResponse) -> ());
    func DELETEFromCart(completion: @escaping (HTTPURLResponse) -> ());
}
