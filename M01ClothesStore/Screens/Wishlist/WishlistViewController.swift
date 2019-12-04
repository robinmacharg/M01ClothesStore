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
            let product = Repository.shared.wishlist[Repository.shared.wishlist.keys.sorted()[ indexPath.row]]
        {
            // Visibility
               
            cell.RHSButton.isHidden = false
            cell.LHSButton.isHidden = false
            
            // Values
            
            cell.rowIndex = indexPath.row
            cell.ID = product.id
            cell.productNameLabel.text = product.name
            cell.categoryLabel.text = product.category
            cell.priceLabel.text = "£\(String(format: "%.2f", product.price))"
            cell.availabilityLabel.isHidden = true
            cell.LHSButton.setImage(UIImage(named: Constants.Images.StarFilled), for: .normal)
            cell.RHSButton.setImage(UIImage(named: Constants.Images.CartAdd), for: .normal)
            
            cell.RHSButton.isEnabled = !(product.stock == 0)
            
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
    
    func RHSButtonTapped(sender: ProductCell, productID: Int) {
        if let index = sender.rowIndex {
            Repository.shared.moveFromWishlistToCart(productId: productID)
            {
                self.tableView.beginUpdates()
                self.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                self.tableView.endUpdates()
            
                // Decrement index of every - visible - row above deletion index
                // Addition of new items (via Catalogue VC) will cause a complete reload
                for case let cell as ProductCell in self.tableView.visibleCells {
                    if let cellIndex = cell.rowIndex, cellIndex > index {
                        cell.rowIndex! -= 1
                    }
                }
                
                self.controller?.updateAppearance()
            }
        }
    }
    
    func LHSButtonTapped(sender: ProductCell, productID: Int) {
        if let index = sender.rowIndex {
            
            // Implicit removal
            Repository.shared.removeFromWishlist(productId: productID)
            {
                self.tableView.beginUpdates()
                self.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                self.tableView.endUpdates()
            
                // Decrement index of every - visible - row above deletion index
                // Addition of new items (via Catalogue VC) will cause a complete reload
                for case let cell as ProductCell in self.tableView.visibleCells {
                    if let cellIndex = cell.rowIndex, cellIndex > index {
                        cell.rowIndex! -= 1
                    }
                }
                
                self.controller?.updateAppearance()
            }
        }
    }
}

// MARK: - <BadgeableTab>

extension WishlistViewController: BadgeableTab {
    var badgeCount: Int? { Repository.shared.wishlist.count }
}
