//
//  FoodModel.swift
//  FoodApp
//
//  Created by Shivaji Tanpure on 08/09/23.
//

import Foundation

protocol FoodModel: AnyObject {
    func fetchFoodItems() async throws -> [Food]
}
