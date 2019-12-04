//
//  AppDelegate.swift
//  M01ClothesStore
//
//  Created by Robin Macharg on 27/11/2019.
//  Copyright © 2019 MachargCorp. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let rootURL = "https://private-anon-b14e15b3c2-ddshop.apiary-mock.com"
        
        Repository.initalise(
            root: rootURL, // TODO: init API with rootURL?
            api: ClothesStoreAPI(),
            model: ClothesStoreModel())
        
        return true
    }
}

