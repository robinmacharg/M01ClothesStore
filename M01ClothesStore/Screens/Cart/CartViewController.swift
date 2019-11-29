//
//  CartViewController.swift
//  M01ClothesStore
//
//  Created by Robin Macharg on 28/11/2019.
//  Copyright © 2019 MachargCorp. All rights reserved.
//

import UIKit

class CartViewController: UIViewController {
    
    @IBOutlet weak var TableView: UITableView!
    
    override func viewDidLoad() {
        TableView.register(
            UINib(nibName: "ProductCell", bundle: Bundle.main),
            forCellReuseIdentifier: Constants.UI.ProductCell)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        TableView.reloadData()
    }
}

// MARK: - <UITableViewDataSource>

extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Repository.shared.Cart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let productId = Repository.shared.orderedCartKeys[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.UI.ProductCell, for: indexPath) as? ProductCell,
            let product = Repository.shared.Catalogue[productId]
        {
            cell.ID = product.id
            cell.ProductNameLabel.text = product.name
            cell.CategoryLabel.text = product.category
            cell.PriceLabel.isHidden = true
            cell.AvailabilityLabel.text = "\(Repository.shared.Cart[productId]?.count ?? 0) items"
            cell.AddProductButton.isHidden = true
            
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

