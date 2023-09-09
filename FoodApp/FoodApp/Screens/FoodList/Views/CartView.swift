//
//  CartView.swift
//  FoodApp
//
//  Created by Shivaji Tanpure on 09/09/23.
//

import SwiftUI

struct CartView: View {
    @ObservedObject var viewModel: FoodViewModel
    
    var body: some View {
        ScrollView {
            if viewModel.items.count > 0 {
                ForEach(viewModel.items, id: \.id) { item in
                    ProductRow(viewModel: viewModel, product: item)
                }
                HStack {
                    Text("Your cart total is")
                    Spacer()
                    Text("£\(viewModel.total.stringValue())")
                        .bold()
                }
                .padding()
                
            } else {
                Text("Your cart is empty.")
            }
        }
        .navigationTitle(Text("My Cart"))
        .padding(.top)
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView(
            viewModel: FoodViewModel(model: FakeFoodModel())
        )
    }
}
