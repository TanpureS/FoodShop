//
//  NumberFormatter.swift
//  FoodApp
//
//  Created by Shivaji Tanpure on 09/09/23.
//

import Foundation

extension Double {
    func stringValue() -> String {
        String(format: "%.02f", self)
    }
}
