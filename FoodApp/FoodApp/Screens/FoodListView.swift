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
    var columns = [GridItem(.adaptive(minimum: 160), spacing: 20)]
    
    var body: some View {
        NavigationView {
            ScrollView {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(viewModel.items, id: \.id) { item in
                            FoodCard(viewModel: viewModel, food: item)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("food_items_view.title")
            .task {
                viewModel.loadData()
            }
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
        func loadImage(from url: String) async throws -> UIImage {
            return UIImage(named: "food-placeholder")!
        }
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
}
