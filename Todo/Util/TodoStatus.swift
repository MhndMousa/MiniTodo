//
//  TodoStatus.swift
//  Todo
//
//  Created by Muhannad Alnemer on 2/20/20.
//  Copyright © 2020 Muhannad Alnemer. All rights reserved.
//

import Foundation

enum TodoStatus: Int,Codable,CaseIterable {
    case unfinished = 0, finished
    var description :String {
        switch self {
        case .unfinished:   return "Unfinished"
        case .finished:     return "Finished"
        }
    }
    var opposite :TodoStatus {
        switch self {
        case .unfinished:   return .finished
        case .finished:     return .unfinished
        }
    }
}
