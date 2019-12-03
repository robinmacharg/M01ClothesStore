//
//  TabBarController.swift
//  M01ClothesStore
//
//  Created by Robin Macharg on 03/12/2019.
//  Copyright © 2019 MachargCorp. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    // TODO: move this to a protocol
    // Iterate over tabs, requesting badge count from suitably conforming VCs
    func updateAppearance() {
        guard let items = self.tabBar.items?.enumerated() else { return }

        for (i, item) in items {
            if let badgeCount = (viewControllers?[i] as? BadgeableTab)?.badgeCount {
                item.badgeValue = badgeCount == 0
                    ? nil
                    : "\(badgeCount)"
            }
        }
    }
}
