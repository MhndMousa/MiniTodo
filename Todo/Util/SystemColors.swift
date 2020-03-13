//
//  SystemColors.swift
//  Todo
//
//  Created by Muhannad Alnemer on 2/22/20.
//  Copyright © 2020 Muhannad Alnemer. All rights reserved.
//

import UIKit
enum SystemColors:String, CaseIterable {
    case red
    case green
    case blue
    case orange
//    case systemYellow
    case pink
    case purple
//    case systemTeal
    case indigo
    
    var color : UIColor{
        switch self {
        case .red : return UIColor.systemRed
        case .green : return UIColor.systemGreen
        case .blue : return UIColor.systemBlue
        case .orange : return UIColor.systemOrange
//        case .systemYellow : return UIColor.systemYellow
        case .pink : return UIColor.systemPink
        case .purple : return UIColor.systemPurple
//        case .systemTeal : return UIColor.systemTeal
        case .indigo : return UIColor.systemIndigo
        }
    }
    static func random() -> UIColor{
        return SystemColors.allCases.randomElement()!.color
    }
    static func systemRandom() -> SystemColors{
        return SystemColors.allCases.randomElement()!
    }
}
