//
//  ProductCellDelegate.swift
//  M01ClothesStore
//
//  Created by Robin Macharg on 29/11/2019.
//  Copyright © 2019 MachargCorp. All rights reserved.
//

import Foundation

protocol ProductCellDelegate {
    func button1Tapped(sender: ProductCell, productID: Int)
    func button2Tapped(sender: ProductCell, productID: Int)
}

extension ProductCellDelegate {

    // Button actions are optional.
    func button1Tapped(sender: ProductCell, productID: Int) {}
    func button2Tapped(sender: ProductCell, productID: Int) {}
}
