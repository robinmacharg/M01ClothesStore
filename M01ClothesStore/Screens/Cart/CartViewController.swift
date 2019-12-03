//
//  CartViewController.swift
//  M01ClothesStore
//
//  Created by Robin Macharg on 28/11/2019.
//  Copyright © 2019 MachargCorp. All rights reserved.
//

import UIKit

class CartViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cartTotalLabel: UILabel!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        tableView.register(
            UINib(nibName: "ProductCell", bundle: Bundle.main),
            forCellReuseIdentifier: Constants.UI.ProductCell)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        updateCartTotal()
    }
    
    // MARK: - Helpers
    
    func updateCartTotal() {
        var items = Repository.shared.cart.count
        var itemText = items == 1 ? "item" : "items"
        cartTotalLabel.text = "Total (\(items) \(itemText)): £\(Repository.shared.cartTotal)"
    }
    
}

// MARK: - <UITableViewDataSource>

extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Repository.shared.cart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.UI.ProductCell, for: indexPath) as? ProductCell
        {
            let product = Repository.shared.cart[indexPath.row]
            
            // Visibility
            
            cell.RHSButton.isHidden = false
            cell.LHSButton.isHidden = true
            
            cell.rowIndex = indexPath.row
            cell.ID = product.id
            cell.productNameLabel.text = product.name
            cell.categoryLabel.text = product.category
            cell.priceLabel.text = "£\(String(format: "%.2f", product.price))"
            cell.availabilityLabel.isHidden = true
            cell.RHSButton.setImage(UIImage(named: Constants.Images.CartRemove), for: .normal)
            cell.delegate = self
            return cell
        }
    
        else {
            fatalError("Can't instantiate a valid Product Cell for the Cart")
        }
    }
}

// MARK: - <UITableViewDelegate>

extension CartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

// MARK: - <ProductCellDelegate>

extension CartViewController: ProductCellDelegate {
    func RHSButtonTapped(sender: ProductCell, productID: Int) {
        if let index = sender.rowIndex {
            Repository.shared.removeProductFromCart(index: index) {
                
                // Async completion block:

                // Update the header total
                self.updateCartTotal()
                
                // Animate deletions
                self.tableView.beginUpdates()
                self.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                
                // Decrement index of every - visible - row above deletion index
                // Addition of new items (via Catalogue VC) will cause a complete reload
                for case let cell as ProductCell in self.tableView.visibleCells {
                    if let cellIndex = cell.rowIndex, cellIndex > index {
                        cell.rowIndex! -= 1
                    }
                }
                
                self.tableView.endUpdates()
            }
        }
    }
}

