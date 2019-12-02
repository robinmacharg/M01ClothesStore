//
//  ProductCell.swift
//  M01ClothesStore
//
//  Created by Robin Macharg on 29/11/2019.
//  Copyright © 2019 MachargCorp. All rights reserved.
//

import UIKit

class ProductCell: UITableViewCell {
    
    var delegate: ProductCellDelegate?
    var ID: Int?
    var rowIndex: Int?
    
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var availabilityLabel: UILabel!
    @IBOutlet weak var addProductButton: UIButton!
    
    @IBAction func cartButtonTapped(_ sender: Any) {
        delegate?.cartButtonTapped(
            sender: self,
            productID: self.ID ?? -1)
    }
}
