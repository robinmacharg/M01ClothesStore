//
//  ModelProtocol.swift
//  M01ClothesStore
//
//  Created by Robin Macharg on 28/11/2019.
//  Copyright © 2019 MachargCorp. All rights reserved.
//

import Foundation

enum Store {
    case catalogue
    case wishlist
    case cart
}

protocol Model {
    // CRUD operations
    func create(_ product: Product, in: Store, _ completion: (() -> ())?)
    func get(itemWithId: Int, from: Store) -> Product?
    func get(itemAtIndex: Int, from: Store) -> Product?
    func update(product: Product, in: Store, _ completion: (() -> ())?)
    func remove(at: Int, from: Store, _ completion: (() -> ())?)
    func remove(id: Int, from: Store, _ completion: (() -> ())?)
    
    // Other operations
    func count(of: Store) -> Int
    var cartTotal: Double { get }
}
