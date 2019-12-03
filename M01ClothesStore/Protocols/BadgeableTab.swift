//
//  BadgeableTab.swift
//  M01ClothesStore
//
//  Created by Robin Macharg on 03/12/2019.
//  Copyright © 2019 MachargCorp. All rights reserved.
//

import UIKit

protocol BadgeableTab where Self: UIViewController {
    var badgeCount: Int? { get }
    var controller: BadgedTabsTabController? { get }
}

extension BadgeableTab {
    var controller: BadgedTabsTabController? { self.tabBarController as? BadgedTabsTabController}
}

