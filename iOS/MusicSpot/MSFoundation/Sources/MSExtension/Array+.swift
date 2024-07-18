//
//  Array+.swift
//  MSExtension
//
//  Created by 이창준 on 7/18/24.
//

extension Array {
    public subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
