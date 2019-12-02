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
    
    
    override func viewDidLoad() {
        tableView.register(
            UINib(nibName: "ProductCell", bundle: Bundle.main),
            forCellReuseIdentifier: Constants.UI.ProductCell)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
}

// MARK: - <UITableViewDataSource>

extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Repository.shared.Cart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.UI.ProductCell, for: indexPath) as? ProductCell
        {
            let product = Repository.shared.Cart[indexPath.row]
            cell.rowIndex = indexPath.row
            cell.ID = product.id
            cell.productNameLabel.text = product.name
            cell.categoryLabel.text = product.category
            cell.priceLabel.isHidden = true
            cell.availabilityLabel.isHidden = true
//            cell.AddProductButton.isHidden = true
            
            cell.addProductButton.setImage(UIImage(systemName: "cart.badge.minus"), for: .normal)
            
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
    func cartButtonTapped(sender: ProductCell, productID: Int) {
        if let index = sender.rowIndex {
            Repository.shared.removeProductFromCart(index: index) {
                
                // Async completion block:
                
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

