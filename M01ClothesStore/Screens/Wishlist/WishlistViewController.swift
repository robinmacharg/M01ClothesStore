//
//  WishlistViewController.swift
//  M01ClothesStore
//
//  Created by Robin Macharg on 28/11/2019.
//  Copyright © 2019 MachargCorp. All rights reserved.
//

import UIKit

class WishlistViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        tableView.register(
            UINib(nibName: "ProductCell", bundle: Bundle.main),
            forCellReuseIdentifier: Constants.UI.ProductCell)
        
        Repository.shared.GETProducts(completion: { response in
            self.tableView.reloadData()
        })
    }
}

// MARK: - <UITableViewDataSource>

extension WishlistViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Repository.shared.Wishlist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.UI.ProductCell, for: indexPath) as? ProductCell,
            let product = Repository.shared.Catalogue[Repository.shared.orderedCatalogueKeys[ indexPath.row]]
        {
            // Visibility
                       
            cell.addProductButton.isHidden = false
            cell.wishlistButton.isHidden = true
            
            // Values
            
            cell.rowIndex = indexPath.row
            cell.ID = product.id
            cell.productNameLabel.text = product.name
            cell.categoryLabel.text = product.category
            cell.priceLabel.text = "£\(String(format: "%.2f", product.price))"
            cell.availabilityLabel.text = "\(product.stock) Available"
            cell.addProductButton.setImage(UIImage(named: "star-empty"), for: .normal)
            cell.delegate = self
            
            return cell
        }
            
        else {
            fatalError("Can't instantiate a valid Product Cell for the Wishlist")
        }
    }
}

// MARK: - <UITableViewDelegate>

extension WishlistViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100 // TODO: Extract from XIB
    }
}

extension WishlistViewController: ProductCellDelegate {
    func cartButtonTapped(sender: ProductCell, productID: Int) {
//        Repository.shared.addProductToCart(productID: productID) {
//            if let rowIndex = sender.rowIndex {
//                self.tableView.reloadRows(at: [IndexPath(row: rowIndex, section: 0)], with: .none)
//            }
//        }
    }
    
//    func wishlistButtonTapped(sender: ProductCell, productID: Int) {
//
//    }
}
