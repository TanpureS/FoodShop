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
                    Text("cart_total.message")
                    Spacer()
                    Text("£\(viewModel.total.stringValue())")
                        .bold()
                }
                .padding()
                
                PaymentButton(action: { viewModel.pay() })
                    .padding()
                
            } else {
                Text("cart_empty.message")
                    .font(.title)
            }
        }
        .navigationTitle(Text("cart_view.title"))
        .padding(.top)
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView(
            viewModel: FoodViewModel(model: FakeFoodModel(), paymentHandler: FakePaymentProcessor())
        )
    }
}
