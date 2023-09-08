//
//  DefaultFoodModel.swift
//  FoodApp
//
//  Created by Shivaji Tanpure on 08/09/23.
//

import Foundation
import SwiftUI

final class DefaultFoodModel: FoodModel {
    
    // MARK: API
    
    func fetchFoodItems() async throws -> [Food] {
        guard let url = URL(string: NetworkManager.shared.appetizerURL) else {
            throw NetWorkError.invalidURL
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let decodedResponse = try JSONDecoder().decode(AppetizerResponse.self, from: data)
        return decodedResponse.request
    }
}
