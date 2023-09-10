//
//  FoodListViewModel_Tests.swift
//  FoodAppTests
//
//  Created by Shivaji Tanpure on 09/09/23.
//

@testable import FoodApp
import XCTest
import SwiftUI

class FoodListViewModel_Tests: XCTestCase {
    // MARK: Properties
    
    private let model = FoodModelStub()
    private let paymentHandler = PaymentHandlerStub()
    
    private lazy var sut = FoodViewModel(model: model, paymentHandler: paymentHandler)
    
    // MARK: Stubs
    lazy var searchTextGetter = getter(of: sut.searchText)
        
    // MARK: Tests
    
    func test_StateIs_IdleByDefault() {
        switch sut.state {
            case .idle: break
            default: XCTFail("Unexpected state: \(sut.state)")
        }
    }
    
    func test_StateIs_LoadingWhenFetchingIsNotCompleted() async {
        model.fetchFoodItemsStub = { [] }
        
        await sut.loadData()
        
        switch sut.state {
            case .loading: break
            default: XCTFail("Unexpected state: \(sut.state)")
        }
    }
    
    func test_StateIs_Error_WhenModelThrowsError() async {
        model.fetchFoodItemsStub = { throw NetWorkError.unknown }
        
        await sut.loadData()
        
        waitUntil(sut.$state) { value in if case .error = value { return true } else { return false } }
            
        switch sut.state {
            case .error: break
            default: XCTFail("ViewModel is in unexpected state: \(sut.state)")
        }
    }
    
    func test_StateIs_Loaded_ApiResponseContainsExpectedData() async throws {
        model.fetchFoodItemsStub = { Food.items }
        
        await sut.loadData()
        
        waitUntil(sut.$state) { state in  state.data != nil }
        
        XCTAssertNotNil(sut.state.data)
        
        let isResponseEmpty = try XCTUnwrap(sut.state.data?.isEmpty)
        
        XCTAssertFalse(isResponseEmpty)
        
        XCTAssertEqual(sut.state.data?.count, 1)
    }
    
    func test_State_ItemsEmptyByPassingSearchStringNotMatching() async throws {
        model.fetchFoodItemsStub = { Food.items }
        
        await sut.loadData()
        
        waitUntil(sut.$state) { state in  state.data != nil }

        // Tests search texts is empty initially & filtered array contains 1 item
        XCTAssertTrue(sut.searchText.isEmpty)
       
        XCTAssertEqual(sut.filteredItems.count, 1)

        //pass search text
        searchTextGetter = { "Shrimp" }
        sut.searchText = searchTextGetter()
        
        // Tests search texts is not empty & filtered array is an empty
        XCTAssertFalse(sut.searchText.isEmpty)
        
        XCTAssertEqual(sut.filteredItems.count, 0)
    }
    
    func test_State_ItemsContainsValueByPassingSearchStringMatching() async throws {
        model.fetchFoodItemsStub = { Food.items }
        
        await sut.loadData()
        
        waitUntil(sut.$state) { state in  state.data != nil }

        // Tests search texts is empty initially & filtered array contains 1 item
        XCTAssertTrue(sut.searchText.isEmpty)
       
        XCTAssertEqual(sut.filteredItems.count, 1)

        //pass search text
        searchTextGetter = { "Asian" }
        sut.searchText = searchTextGetter()
        
        // Tests search texts is not empty & filtered array contains 1 item
        XCTAssertFalse(sut.searchText.isEmpty)
        
        XCTAssertEqual(sut.filteredItems.count, 1)
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
        )
    ]
}
