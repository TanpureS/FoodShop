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
    @Published private(set) var items: [Food] = []
    @Published private(set) var total: Double = 0
    
    // MARK: Initialiser
    
    init(model: FoodModel) {
        self.model = model
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
}


