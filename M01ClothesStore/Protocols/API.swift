//
//  APIProtocol.swift
//  M01ClothesStore
//
//  Created by Robin Macharg on 28/11/2019.
//  Copyright © 2019 MachargCorp. All rights reserved.
//

import Foundation

protocol API {
    func GETProducts(completion: @escaping (_ response: HTTPURLResponse) -> ());
//    func GETProductDetails();
    func POSTToCart(product: Product, completion: @escaping (HTTPURLResponse) -> ());
//    func DELETEFromCart(product: Product);
}
