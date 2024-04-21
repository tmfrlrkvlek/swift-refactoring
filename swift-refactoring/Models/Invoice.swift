//
//  Invoice.swift
//  swift-refactoring
//
//  Created by 이지수 on 4/21/24.
//

import Foundation

struct Invoice: Codable {
    let customer: String
    let performances: [Performance]
}
