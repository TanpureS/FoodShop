//
//  ViewState.swift
//  FoodApp
//
//  Created by Shivaji Tanpure on 09/09/23.
//

import Foundation

enum ViewState<DataType, ErrorType: Error> {
    case idle
    case loading
    case loaded(DataType)
    case error(ErrorType)
    
    var data: DataType? {
        if case let .loaded(data) = self { return data }
        return nil
    }
    
    var error: ErrorType? {
        if case let .error(error) = self { return error }
        return nil
    }
}

extension ViewState: Equatable where DataType: Equatable {
    static func == (lhs: ViewState, rhs: ViewState) -> Bool {
        switch (lhs, rhs) {
            case (.idle, .idle): return true
            case (.loading, .loading): return true
            case let (.loaded(lhsData), .loaded(rhsData)): return lhsData == rhsData
            case let (.error(lhsError), .error(rhsError)): return lhsError.localizedDescription == rhsError.localizedDescription
            default:  return false
        }
    }
}
