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
    
    // MARK: - Outlets
    
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var availabilityLabel: UILabel!
    @IBOutlet weak var RHSButton: UIButton!
    @IBOutlet weak var LHSButton: UIButton!
    
    // MARK: - Actions
    
    @IBAction func cartButtonTapped(_ sender: Any) {
        delegate?.RHSButtonTapped(
            sender: self,
            productID: self.ID ?? -1)
    }
    
    @IBAction func wishlistButtonTapped(_ sender: Any) {
        delegate?.LHSButtonTapped(
            sender: self,
            productID: self.ID ?? -1)
    }
}
