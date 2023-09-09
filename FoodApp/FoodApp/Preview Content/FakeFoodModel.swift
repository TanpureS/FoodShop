//
//  FakeFoodModel.swift
//  FoodApp
//
//  Created by Shivaji Tanpure on 09/09/23.
//

import Foundation
import UIKit

final class FakeFoodModel: FoodModel {
    
    static let foodItem = Food(
        id: 1,
        name: "Asian Flank Steak",
        price: 12.3,
        imageURL: "https://seanallen-course-backend.herokuapp.com//images//appetizers//asian-flank-steak.jpg",
        description: "",
        calories: 300,
        carbs: 0,
        protein: 14
    )
    
    func fetchFoodItems() async throws -> [Food] {
        [Food(
            id: 1,
            name: "Asian Flank Steak",
            price: 12.3,
            imageURL: "https://seanallen-course-backend.herokuapp.com//images//appetizers//asian-flank-steak.jpg",
            description: "",
            calories: 300,
            carbs: 0,
            protein: 14
        )]
    }
}
