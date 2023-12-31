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
                if case .loading = viewModel.state {
                    LoaderView()
                } else if case .loaded = viewModel.state {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(viewModel.filteredItems, id: \.id) { item in
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
            .alert("food_items_error.message", isPresented: .constant(viewModel.state.error != nil)) {
                Button("Retry", role: .cancel) { [viewModel] in
                    viewModel.loadData()
                }
            }
            .toolbar {
                NavigationLink {
                    CartView(viewModel: viewModel)
                } label: {
                    CartButton(numberOfProducts: viewModel.cartItems.count)
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .searchable(text: $viewModel.searchText, prompt: "food_items_search.placeholder")
    }
}

struct FoodListView_Previews: PreviewProvider {
    static var previews: some View {
        FoodListView(
            viewModel: FoodViewModel(dataService: FakeDataService(), paymentHandler: FakePaymentProcessor())
        )
    }
}
