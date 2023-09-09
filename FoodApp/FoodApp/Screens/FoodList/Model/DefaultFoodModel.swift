//
//  DefaultFoodModel.swift
//  FoodApp
//
//  Created by Shivaji Tanpure on 08/09/23.
//

import Foundation
import SwiftUI

final class DefaultFoodModel: FoodModel {
    
    let baseURL = "https://seanallen-course-backend.herokuapp.com/"
    
    private enum Endpoint: String {
        case appetizers = "swiftui-fundamentals/appetizers"
    }
    
    // MARK: API
    
    func fetchFoodItems() async throws -> [Food] {
        let requestURL = baseURL + Endpoint.appetizers.rawValue
        guard let url = URL(string: requestURL) else {
            throw NetWorkError.invalidURL
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let decodedResponse = try JSONDecoder().decode(AppetizerResponse.self, from: data)
        return decodedResponse.request
    }
}
