//
//  BadgeableTab.swift
//  M01ClothesStore
//
//  Created by Robin Macharg on 03/12/2019.
//  Copyright © 2019 MachargCorp. All rights reserved.
//

import UIKit

/**
 A UITabBarController that badges its tabs
 */
protocol BadgedTabsTabController: UITabBarController {
    func updateAppearance()
}

/**
 A ViewController that is contained in a TabController and provides tab badge info
 */
protocol BadgeableTab where Self: UIViewController {
    var badgeCount: Int? { get }
    var controller: BadgedTabsTabController? { get }
}

extension BadgeableTab {
    var controller: BadgedTabsTabController? { return self.tabBarController as? BadgedTabsTabController}
}

