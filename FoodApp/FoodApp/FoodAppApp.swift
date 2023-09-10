//
//  FoodAppApp.swift
//  FoodApp
//
//  Created by Shivaji Tanpure on 07/09/23.
//

import SwiftUI

@main
struct FoodAppApp: App {
    var body: some Scene {
        WindowGroup {
            let dataService: DataService = AppDataService()
            let paymentHandler: PaymentProcessor = PaymentHandler()
            let viewModel = FoodViewModel(dataService: dataService, paymentHandler: paymentHandler)
            FoodListView(viewModel: viewModel)
        }
    }
}
