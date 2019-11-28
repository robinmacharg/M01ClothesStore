//
//  CatalogueViewController.swift
//  M01ClothesStore
//
//  Created by Robin Macharg on 28/11/2019.
//  Copyright © 2019 MachargCorp. All rights reserved.
//

import UIKit

class CatalogueViewController: UIViewController {
    
    override func viewDidLoad() {
        Repository.shared().getProducts {
            print("CatalogueViewController callback")
        }
    }
}
