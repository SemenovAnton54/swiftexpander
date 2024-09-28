//
//  SwiftExpanderProtocol.swift
//  ExpandSelectionExtension
//
//  Created by Anton Semenov on 28.09.2024.
//

import Foundation

protocol SwiftExpanderProtocol {
    func expandTo(text: String, start: Int, end: Int) -> (start: Int, end: Int)?
}
