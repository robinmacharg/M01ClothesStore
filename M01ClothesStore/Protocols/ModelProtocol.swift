//
//  ModelProtocol.swift
//  M01ClothesStore
//
//  Created by Robin Macharg on 28/11/2019.
//  Copyright © 2019 MachargCorp. All rights reserved.
//

import Foundation

protocol ModelProtocol {
    func parseProducts(products: String, completion: () -> ());
}