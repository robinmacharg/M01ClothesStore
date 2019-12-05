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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
}

// MARK: - <UITableViewDataSource>

extension WishlistViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StoreFacade.shared.count(of: .wishlist)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.UI.ProductCell, for: indexPath) as? ProductCell,
            let product = StoreFacade.shared.get(itemAtIndex: indexPath.row, from: .wishlist)
        {
            cell.RHSButton.isHidden = false
            cell.LHSButton.isHidden = false
            cell.rowIndex = indexPath.row
            cell.ID = product.id
            cell.productNameLabel.text = product.name
            cell.categoryLabel.text = product.category
            cell.priceLabel.text = "£\(String(format: "%.2f", product.price))"
            cell.availabilityLabel.isHidden = true
            cell.LHSButton.setImage(UIImage(named: Constants.Images.StarFilled), for: .normal)
            cell.RHSButton.setImage(UIImage(named: Constants.Images.CartAdd), for: .normal)
            cell.RHSButton.isEnabled = StoreFacade.shared.isInStock(product)
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

// MARK: - <ProductCellDelegate>

extension WishlistViewController: ProductCellDelegate {

    func LHSButtonTapped(sender: ProductCell, productID id: Int) {
        if let index = sender.rowIndex {
            
            StoreFacade.shared.removeFromWishlist(id: id) {
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
    
    func RHSButtonTapped(sender: ProductCell, productID: Int) {
        if let index = sender.rowIndex {
            StoreFacade.shared.moveFromWishlistToCart(id: productID)
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
    var badgeCount: Int? { return StoreFacade.shared.count(of: .wishlist) }
}
