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
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
}

// MARK: - <UITableViewDataSource>

extension WishlistViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Repository.shared.wishlist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.UI.ProductCell, for: indexPath) as? ProductCell,
            let product = Repository.shared.catalogue[Repository.shared.orderedCatalogueKeys[ indexPath.row]]
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
        if let index = sender.rowIndex {
            // Implicit removal
            Repository.shared.removeFromWishlist(productId: productID)
            {
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
