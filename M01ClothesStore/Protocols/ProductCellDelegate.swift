//
//  ProductCellDelegate.swift
//  M01ClothesStore
//
//  Created by Robin Macharg on 29/11/2019.
//  Copyright © 2019 MachargCorp. All rights reserved.
//

import Foundation

protocol ProductCellDelegate {
    func RHSButtonTapped(sender: ProductCell, productID: Int)
    func LHSButtonTapped(sender: ProductCell, productID: Int)
}

extension ProductCellDelegate {

    // Button actions are optional.
    func RHSButtonTapped(sender: ProductCell, productID: Int) {}
    func LHSButtonTapped(sender: ProductCell, productID: Int) {}
}
