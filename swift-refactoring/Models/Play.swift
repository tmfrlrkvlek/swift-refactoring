//
//  Play.swift
//  swift-refactoring
//
//  Created by 이지수 on 4/21/24.
//

import Foundation

typealias Plays =  [String: Play]

struct Play: Codable {
    enum PlayType: String, Codable {
        case tragedy, comedy
    }
    
    let name: String
    let type: PlayType
}

