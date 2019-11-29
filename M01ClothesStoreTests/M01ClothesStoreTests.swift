//
//  M01ClothesStoreTests.swift
//  M01ClothesStoreTests
//
//  Created by Robin Macharg on 27/11/2019.
//  Copyright © 2019 MachargCorp. All rights reserved.
//

import XCTest
@testable import M01ClothesStore

class M01ClothesStoreTests: XCTestCase {

    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testProductIsCodable() {
        let productJsonIn = """
        {
          "productId": 1,
          "name": "Almond Toe Court Shoes, Patent Black",
          "category": "Women's Footwear",
          "price": 99,
          "oldPrice": null,
          "stock": 5
        }
        """
        
        // Check the decoding works
        
        let product1 = try! decoder.decode(
            Product.self,
            from: productJsonIn.data(using: .utf8)!)
        
        XCTAssertEqual(product1.id, 1)
        XCTAssertEqual(product1.name, "Almond Toe Court Shoes, Patent Black")
        XCTAssertEqual(product1.category, "Women's Footwear")
        XCTAssertEqual(product1.price, 99.0)
        XCTAssertEqual(product1.stock, 5)
        
        // Check encoding by encoding and redecoding
        
        let productJsonOut = String(data: try! encoder.encode(product1), encoding: .utf8)!
        
        let product2 = try! decoder.decode(
            Product.self,
            from: productJsonOut.data(using: .utf8)!)
        
        XCTAssertEqual(product1.id, product2.id)
        XCTAssertEqual(product1.name, product2.name)
        XCTAssertEqual(product1.category, product2.category)
        XCTAssertEqual(product1.price, product2.price)
        XCTAssertEqual(product1.stock, product2.stock)
    }

    func testRetrieveAndParseCatalogue() {
        Repository.shared.GETProducts { (_) in
            XCTAssertEqual(Repository.shared.Catalogue?.count, 13)
        }
    }
    
    func testCanPOSTToCart() {
        let expectation = self.expectation(description: "POST works")
        var responseCode: Int?
        
        let product = Product(
            id: 123,
            name: "MyProduct",
            category: "MyCategory",
            price: 3.14,
            stock: 42)
        
        Repository.shared.POSTToCart(product: product) { response in
            responseCode = response.statusCode
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(responseCode == 201)
    }
}
