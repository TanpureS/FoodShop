//
//  ProductRow.swift
//  FoodApp
//
//  Created by Shivaji Tanpure on 09/09/23.
//

import SwiftUI

struct ProductRow: View {
    @ObservedObject var viewModel: FoodViewModel
    var product: Food
    
    var body: some View {
        HStack(spacing: 20) {
            AsyncImage(
                url: URL(string: product.imageURL),
                transaction: Transaction(animation: .default)
            ) { phase in
                switch phase {
                case .success(let image):
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50)
                        .cornerRadius(10)
                default:
                    ProgressView()
                }
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text(product.name)
                    .bold()
                Text("£\(product.price.stringValue())")
            }
            
            Spacer()
            
            Image(systemName: "trash")
                .foregroundColor(Color(hue: 1.0, saturation: 0.89, brightness: 0.835))
                .onTapGesture {
                    viewModel.removeFromCart(item: product)
                }
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct ProductRow_Previews: PreviewProvider {
    static var previews: some View {
        ProductRow(
            viewModel: FoodViewModel(model: FakeFoodModel(), paymentHandler: FakePaymentProcessor()),
            product: FakeFoodModel.foodItem
        )
    }
}
