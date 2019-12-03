//
//  CatalogueViewController.swift
//  M01ClothesStore
//
//  Created by Robin Macharg on 28/11/2019.
//  Copyright © 2019 MachargCorp. All rights reserved.
//

import UIKit

class CatalogueViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        tableView.register(
            UINib(nibName: "ProductCell", bundle: Bundle.main),
            forCellReuseIdentifier: Constants.UI.ProductCell)
        
        Repository.shared.GETProducts(completion: { response in
            self.tableView.reloadData()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
}

// MARK: - <UITableViewDataSource>

extension CatalogueViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Repository.shared.catalogue.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.UI.ProductCell, for: indexPath) as? ProductCell,
            let product = Repository.shared.catalogue[Repository.shared.orderedCatalogueKeys[ indexPath.row]]
        {
            // Visibility
            
            cell.addProductButton.isHidden = false
            cell.wishlistButton.isHidden = false

            // Values

            cell.rowIndex = indexPath.row
            cell.ID = product.id
            cell.productNameLabel.text = product.name
            cell.categoryLabel.text = product.category
            cell.priceLabel.text = "£\(String(format: "%.2f", product.price))"
            cell.availabilityLabel.text = "\(product.stock) Available"
            cell.addProductButton.setImage(UIImage(named: "cart-plus"), for: .normal)
            if Repository.shared.wishlist.keys.contains(product.id) {
                cell.wishlistButton.setImage(UIImage(named: "star-filled"), for: .normal)
            }
            else {
                cell.wishlistButton.setImage(UIImage(named: "star-empty"), for: .normal)
            }
            cell.delegate = self
            
            cell.addProductButton.isEnabled = !(product.stock == 0)
            
            return cell
        }
            
        else {
            fatalError("Can't instantiate a valid Product Cell for the Catalogue")
        }
    }
}

// MARK: - <UITableViewDelegate>

extension CatalogueViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100 // TODO: Extract from XIB
    }
}

// MARK: - <ProductCellDelegate>

extension CatalogueViewController: ProductCellDelegate {

    // Add to cart
    func button1Tapped(sender: ProductCell, productID: Int) {
        Repository.shared.addProductToCart(productID: productID) {
            if let rowIndex = sender.rowIndex {
                self.tableView.reloadRows(at: [IndexPath(row: rowIndex, section: 0)], with: .none)
            }
        }
    }
    
    // Add to wishlist
    func button2Tapped(sender: ProductCell, productID: Int) {
        Repository.shared.toggleWishlistInclusion(productId: productID) {
            if let rowIndex = sender.rowIndex {
                self.tableView.reloadRows(at: [IndexPath(row: rowIndex, section: 0)], with: .none)
            }
        }
    }
}
