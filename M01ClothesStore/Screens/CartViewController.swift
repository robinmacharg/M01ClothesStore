//
//  CartViewController.swift
//  M01ClothesStore
//
//  Created by Robin Macharg on 28/11/2019.
//  Copyright © 2019 MachargCorp. All rights reserved.
//

import UIKit

/**
 * Display the shopping cart in a table
 */
class CartViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cartTotalLabel: UILabel!
    
    private var cellHeight: CGFloat = 100.0
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        tableView.register(
            UINib(nibName: "ProductCell", bundle: Bundle.main),
            forCellReuseIdentifier: Constants.UI.ProductCell)
        
        cellHeight = (Bundle.main
            .loadNibNamed(Constants.UI.ProductCell, owner: self, options: nil)?
            .first as? UITableViewCell)?.contentView.frame.height ?? 0.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        updateCartTotal()
    }
    
    // MARK: - Helpers
    
    func updateCartTotal() {
        let count = StoreFacade.shared.count(of: .cart)
        let itemText = StoreFacade.shared.count(of: .cart) == 1 ? "item" : "items"
        cartTotalLabel.text = "Total (\(count) \(itemText)): £\(StoreFacade.shared.cartTotal)"
    }
}

// MARK: - <UITableViewDataSource>

extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StoreFacade.shared.count(of: .cart)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.UI.ProductCell, for: indexPath) as? ProductCell,
            let product = StoreFacade.shared.get(itemAtIndex: indexPath.row, from: .cart)
        {
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
        return cellHeight
    }
}

// MARK: - <ProductCellDelegate>

extension CartViewController: ProductCellDelegate {
    func RHSButtonTapped(sender: ProductCell, productID: Int) {
        if let index = sender.rowIndex {
            StoreFacade.shared.removeProductFromCart(index: index) {

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
                
                self.controller?.updateAppearance()
            }
        }
    }
}

// MARK: - <BadgeableTab>

extension CartViewController: BadgeableTab {
    var badgeCount: Int? { return StoreFacade.shared.count(of: .cart) }
}
