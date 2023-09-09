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

    private let model: FoodModel

    @Published
    private(set) var state: ViewState<[Food], Error> = .idle
    
    // Cart-related variables
    @Published
    private(set) var items: [Food] = []
    @Published
    private(set) var total: Double = 0
    
    // Payment-related variables
    let paymentHandler: PaymentProcessor
    @Published
    var paymentSuccess = false
    
    // MARK: Initialiser
    
    init(model: FoodModel, paymentHandler: PaymentProcessor) {
        self.model = model
        self.paymentHandler = paymentHandler
    }
    
    // MARK: API
    
    @MainActor
    func loadData() {
        guard state.data == nil else { return }
        state = .loading
        Task {
            do {
                let items = try await model.fetchFoodItems()
                state = .loaded(items)
            } catch {
                state = .error(error)
            }
        }
    }
    
    // Functions to add and remove from cart
    func addToCart(item: Food) {
        items.append(item)
        total += item.price
    }
    
    func removeFromCart(item: Food) {
        items = items.filter { $0.id != item.id }
        total -= item.price
    }
    
    // Call the startPayment function from the PaymentHandler. In the completion handler, set the paymentSuccess variable
    func pay() {
        paymentHandler.startPayment(products: items, total: total) { success in
            self.paymentSuccess = success
            self.items = []
            self.total = 0
        }
    }
}


