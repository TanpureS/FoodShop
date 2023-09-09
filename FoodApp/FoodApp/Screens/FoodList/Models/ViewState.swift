//
//  ViewState.swift
//  FoodApp
//
//  Created by Shivaji Tanpure on 09/09/23.
//

import Foundation

enum ViewState {
    case idle
    case loading
    case loaded(items: [Food])
    
    var data: [Food] {
        if case let .loaded(items) = self { return items }
        return []
    }
}
