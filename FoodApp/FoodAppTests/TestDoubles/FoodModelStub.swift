//
//  FoodModelStub.swift
//  FoodAppTests
//
//  Created by Shivaji Tanpure on 09/09/23.
//

import Foundation
@testable import FoodApp

final class FoodModelStub: FoodModel {
    
    lazy var fetchFoodItemsStub = stub(of: fetchFoodItems)
    
    func fetchFoodItems() async throws -> [Food] {
        try await fetchFoodItemsStub()
    }
}
