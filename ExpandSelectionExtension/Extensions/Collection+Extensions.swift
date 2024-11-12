//
//  Array+Extensions.swift
//  ExpandSelection
//
//  Created by Anton Semenov on 11.11.2024.
//

extension Collection {
    // Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
