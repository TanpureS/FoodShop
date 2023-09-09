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
    
    enum ViewState {
        case idle
        case loading
        case loaded(items: [Food])
    }
    
    @Published var state: ViewState = .idle
    @Published var shouldDisplayErrorAlert = false
    
    // MARK: Initialiser
    
    init(model: FoodModel) {
        self.model = model
    }
    
    // MARK: API
    
    @MainActor
    func loadData() {
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
}
