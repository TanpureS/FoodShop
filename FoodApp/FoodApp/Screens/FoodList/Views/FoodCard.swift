//
//  FoodCard.swift
//  FoodApp
//
//  Created by Shivaji Tanpure on 08/09/23.
//

import SwiftUI

struct FoodCard: View {
    @ObservedObject var viewModel: FoodViewModel
    var food: Food
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            ZStack(alignment: .bottom) {
                AsyncImage(url: URL(string: food.imageURL)) { image in
                    image.resizable()
                        .cornerRadius(20)
                        .frame(width: 180)
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                VStack(alignment: .leading) {
                    Text(food.name)
                        .bold()
                    
                    Text("£\(food.price)")
                        .font(.caption)
                }
                .padding()
                .frame(width: 180, alignment: .leading)
                .background(.ultraThinMaterial)
                .cornerRadius(20)
            }
            .frame(width: 180, height: 250)
            .shadow(radius: 3)
            
            Button {
                // cartManager.addToCart(product: product)
            } label: {
                Image(systemName: "plus")
                    .padding(10)
                    .foregroundColor(.white)
                    .background(.black)
                    .cornerRadius(50)
                    .padding()
            }
        }
    }
}

struct FoodCard_Previews: PreviewProvider {
    static var previews: some View {
        FoodCard(
            viewModel: FoodViewModel(model: FakeFoodModel()),
            food: FoodCard_Previews.foodItem
        )
    }
    
    private class FakeFoodModel: FoodModel {
        func fetchFoodItems() async throws -> [Food] {
            [FoodCard_Previews.foodItem]
        }
    }
    
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
}
