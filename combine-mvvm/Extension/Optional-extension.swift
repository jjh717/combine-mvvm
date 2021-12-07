//
//  Optional-extension.swift
//  combine-mvvm
//
//  Created by Louis on 2021/11/25.
//

import Foundation

public extension Optional where Wrapped == String {
    func unwrapped () -> String {
        guard let value: String = self else { return "" }
        return value
    }
}
