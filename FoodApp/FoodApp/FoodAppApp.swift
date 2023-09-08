//
//  FoodAppApp.swift
//  FoodApp
//
//  Created by Shivaji Tanpure on 07/09/23.
//

import SwiftUI

@main
struct FoodAppApp: App {
    var body: some Scene {
        WindowGroup {
            let model: FoodModel = DefaultFoodModel()
            let viewModel = FoodViewModel(model: model)
            FoodListView(viewModel: viewModel)
        }
    }
}
