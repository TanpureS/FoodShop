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

    @Published var state: ViewState = .idle
    @Published var shouldDisplayErrorAlert = false
    
    // Cart-related variables
    @Published private(set) var items: [Food] = []
    @Published private(set) var total: Double = 0
    
    // MARK: Initialiser
    
    init(model: FoodModel) {
        self.model = model
    }
    
    // MARK: API
    
    @MainActor
    func loadData() {
        guard state.data.isEmpty else { return }
        shouldDisplayErrorAlert = false
        self.state = .loading
        Task { [weak self] in
            do {
                let items = try await model.fetchFoodItems()
                self?.state = .loaded(items: items)
            } catch {
                self?.state = .idle
                shouldDisplayErrorAlert = true
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
}


