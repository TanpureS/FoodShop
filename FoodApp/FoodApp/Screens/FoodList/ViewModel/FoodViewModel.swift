//
//  FoodViewModel.swift
//  FoodApp
//
//  Created by Shivaji Tanpure on 08/09/23.
//

import Foundation

final class FoodViewModel: ObservableObject {
    // MARK: Properties
    
    @Published private(set) var items: [Food] = []
    @Published private(set) var isLoading = false
    
    private let model: FoodModel
    
    // MARK: Initialiser
    
    init(model: FoodModel) {
        self.model = model
    }
    
    // MARK: API
    
    @MainActor
    func loadData() {
        isLoading = true
        Task {
            do {
                items = try await model.fetchFoodItems()
                isLoading = false
            } catch(let error) {
                isLoading = false
                // TODO error handling
            }
        }
    }
}
