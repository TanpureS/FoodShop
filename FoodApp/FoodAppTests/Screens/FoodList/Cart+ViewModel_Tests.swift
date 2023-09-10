//
//  Cart+ViewModel_Tests.swift
//  FoodAppTests
//
//  Created by Shivaji Tanpure on 10/09/23.
//

@testable import FoodApp
import XCTest

class Cart_ViewModel_Tests: XCTestCase {
    // MARK: Properties
    
    private let model = FoodModelStub()
    private let paymentHandler = PaymentHandlerStub()
    
    private lazy var sut = FoodViewModel(model: model, paymentHandler: paymentHandler)
        
    // MARK: Cart Tests
   
    func test_State_AddingItemsIntoCart() throws {
        XCTAssertEqual(Food.items.count, 2)

        let firstItem = try XCTUnwrap(Food.items.first)
        
        XCTAssertTrue(sut.cartItems.isEmpty)
        
        sut.addToCart(item: firstItem)
        
        XCTAssertFalse(sut.cartItems.isEmpty)
    
        let secondItem = Food.items[1]
        
        sut.addToCart(item: secondItem)

        XCTAssertEqual(sut.cartItems.count, 2)
    }
    
    func test_State_RemovingItemsFromCart() throws {
        XCTAssertEqual(Food.items.count, 2)
        
        // Adding 2 items into cart
        let firstItem = Food.items[0]
        sut.addToCart(item: firstItem)
        
        let secondItem = Food.items[1]
        sut.addToCart(item: secondItem)
        
        XCTAssertEqual(sut.cartItems.count, 2)
        
        //Remove last item from cart
        let lastItem = try XCTUnwrap(sut.cartItems.last)
        sut.removeFromCart(item: lastItem)
        
        //Test count reduced after item deleted
        XCTAssertEqual(sut.cartItems.count, 1)
    }
    
    func test_TotalPriceOfItemsAddedIntoCart() {
        //check cart is empty initially
        XCTAssertTrue(sut.cartItems.isEmpty)
        XCTAssertEqual(sut.total, 0.0)
        
        // Adding first item into cart
        let firstItem = Food.items[0]
        sut.addToCart(item: firstItem)
        
        //Test total items price in cart after first item added into cart
        XCTAssertEqual(sut.total, 12.3)
        
        let secondItem = Food.items[1]
        sut.addToCart(item: secondItem)
        
        //check cart is not empty
        XCTAssertFalse(sut.cartItems.isEmpty)
        
        //Test total items price
        XCTAssertEqual(sut.total, 19.29)
    }
}

extension Food {
    fileprivate static let items = [
        Food(
            id: 1,
            name: "Asian Flank Steak",
            price: 12.3,
            imageURL: "https://seanallen-course-backend.herokuapp.com//images//appetizers//asian-flank-steak.jpg",
            description: "",
            calories: 300,
            carbs: 0,
            protein: 14
        ),
        Food(
            id: 2,
            name: "Blackened Shrimp",
            price: 6.99,
            imageURL: "https://seanallen-course-backend.herokuapp.com/images/appetizers/blackened-shrimp.jpg",
            description: "Seasoned shrimp from the depths of the Atlantic Ocean.",
            calories: 450,
            carbs: 3,
            protein: 4
        )
    ]
}
