//
//  ContentView.swift
//  FoodApp
//
//  Created by Shivaji Tanpure on 07/09/23.
//

import SwiftUI

struct FoodListView: View {
    // MARK: Properties

    @ObservedObject var viewModel: FoodViewModel
    
    var body: some View {
        NavigationView {
            Text("Hello!")
            .padding()
            
            .navigationTitle("food_items_view.title")
        }
        .task {
            viewModel.loadData()
        }
    }
}

struct FoodListView_Previews: PreviewProvider {
    static var previews: some View {
        FoodListView(
            viewModel: FoodViewModel(model: FakeFoodModel())
        )
    }
    
    private class FakeFoodModel: FoodModel {
        func fetchFoodItems() async throws -> [Food] { [] }
    }
}
