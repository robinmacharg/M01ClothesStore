//
//  Repository.swift
//  M01ClothesStore
//
//  Created by Robin Macharg on 28/11/2019.
//  Copyright © 2019 MachargCorp. All rights reserved.
//

import Foundation

/**
 A Singleton data access respository.
 Provides injection-configurable backend web API access and local Model data access.
 */

class Repository {

    // MARK: - Properties

    private static var sharedRepository: Repository = {
        let repository = Repository()
        return repository
    }()

    var API: APIProtocol?
    var Model: ModelProtocol?
    
    // Initialization

    private init() {}

    // MARK: - Accessors

    class func shared() -> Repository {
        return sharedRepository
    }

}
