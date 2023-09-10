//
//  FoodViewModel.swift
//  FoodApp
//
//  Created by Shivaji Tanpure on 08/09/23.
//

import Foundation
import SwiftUI

final class FoodViewModel: ObservableObject {
    // MARK: Properties

    private let dataService: DataService

    @Published
    private(set) var state: ViewState<[Food], Error> = .idle
    
    // Cart-related variables
    @Published
    private(set) var cartItems: [Food] = []
    @Published
    private(set) var total: Double = 0.0
    
    // Payment-related variables
    let paymentHandler: PaymentProcessor
    @Published
    var paymentSuccess = false

    // Searching-related variables
    @Published
    var searchText = ""

    var filteredItems: [Food] {
        if searchText.isEmpty {
            return state.data ?? []
        } else {
            return state.data?.filter { $0.name.contains(searchText) } ?? []
        }
    }
    
    // MARK: Initialiser
    
    init(dataService: DataService, paymentHandler: PaymentProcessor) {
        self.dataService = dataService
        self.paymentHandler = paymentHandler
    }
    
    // MARK: API
    
    @MainActor
    func loadData() {
        guard state.data == nil else { return }
        state = .loading
        Task {
            do {
                let items = try await dataService.fetchFoodItems()
                state = .loaded(items)
            } catch {
                state = .error(error)
            }
        }
    }
    
    // Functions to add and remove from cart
    func addToCart(item: Food) {
        cartItems.append(item)
        total += item.price
    }
    
    func removeFromCart(item: Food) {
        cartItems = cartItems.filter { $0.id != item.id }
        total -= item.price
    }
    
    // Call the startPayment function from the PaymentHandler. In the completion handler, set the paymentSuccess variable
    func pay() {
        paymentHandler.startPayment(products: cartItems, total: total) { success in
            self.paymentSuccess = success
            self.cartItems = []
            self.total = 0.0
        }
    }
}


