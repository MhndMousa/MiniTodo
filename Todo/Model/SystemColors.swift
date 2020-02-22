//
//  SystemColors.swift
//  Todo
//
//  Created by Muhannad Alnemer on 2/22/20.
//  Copyright © 2020 Muhannad Alnemer. All rights reserved.
//

import UIKit
enum SystemColors:String, CaseIterable {
    case systemRed
    case systemGreen
    case systemBlue
    case systemOrange
    case systemYellow
    case systemPink
    case systemPurple
    case systemTeal
    case systemIndigo
    
    
    var color : UIColor{
        switch self {
        case .systemRed : return UIColor.systemRed
        case .systemGreen : return UIColor.systemGreen
        case .systemBlue : return UIColor.systemBlue
        case .systemOrange : return UIColor.systemOrange
        case .systemYellow : return UIColor.systemYellow
        case .systemPink : return UIColor.systemPink
        case .systemPurple : return UIColor.systemPurple
        case .systemTeal : return UIColor.systemTeal
        case .systemIndigo : return UIColor.systemIndigo
        }
    }
}
