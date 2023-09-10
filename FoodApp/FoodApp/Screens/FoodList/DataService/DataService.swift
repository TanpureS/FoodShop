//
//  DataService.swift
//  FoodApp
//
//  Created by Shivaji Tanpure on 08/09/23.
//

import Foundation
import SwiftUI

protocol DataService: AnyObject {
    func fetchFoodItems() async throws -> [Food]
}
