//
//  CatalogueViewController.swift
//  M01ClothesStore
//
//  Created by Robin Macharg on 28/11/2019.
//  Copyright © 2019 MachargCorp. All rights reserved.
//

import UIKit

class CatalogueViewController: UIViewController {
    
    @IBOutlet weak var TableView: UITableView!
    
    override func viewDidLoad() {
        TableView.register(
            UINib(nibName: "ProductCell", bundle: Bundle.main),
            forCellReuseIdentifier: Constants.UI.ProductCell)
        
        Repository.shared.GETProducts(completion: { response in
            self.TableView.reloadData()
        })
    }
}

// MARK: - <UITableViewDataSource>

extension CatalogueViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Repository.shared.Catalogue?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.UI.ProductCell, for: indexPath) as? ProductCell,
           let product = Repository.shared.Catalogue?[indexPath.row]
        {
            cell.ProductNameLabel.text = product.name
            cell.CategoryLabel.text = product.category
            cell.PriceLabel.text = "£\(String(format: "%.2f", product.price))"
            cell.AvailabilityLabel.text = "\(product.stock) Available"
            return cell
        }
            
        else {
            fatalError("Can't instantiate a valid Product Cell")
        }
    }
}

// MARK: - <UITableViewDelegate>

extension CatalogueViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
