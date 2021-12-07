//
//  Collection-extension.swift
//  combine-mvvm
//
//  Created by Louis on 2021/11/24.
//

import Foundation

public extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
