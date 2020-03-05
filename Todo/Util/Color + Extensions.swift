//
//  Color + Extensions.swift
//  Todo
//
//  Created by Muhannad Alnemer on 3/4/20.
//  Copyright © 2020 Muhannad Alnemer. All rights reserved.
//

import UIKit

class Color:Codable{

    private var _green: CGFloat = 0.0
    private var _blue:  CGFloat = 0.0
    private var _red:   CGFloat = 0.0
    private var alpha:  CGFloat = 0.0
    

    init(color:UIColor) {
        color.getRed(&_red, green: &_green, blue: &_blue, alpha: &alpha)
    }

    var color:UIColor{
        get{
            return UIColor(red: _red, green: _green, blue: _blue, alpha: alpha)
        }
        set{
            newValue.getRed(&_red, green:&_green, blue: &_blue, alpha:&alpha)
        }
    }

    var cgColor:CGColor{
        get{
            return color.cgColor
        }
        set{
            UIColor(cgColor: newValue).getRed(&_red, green:&_green, blue: &_blue, alpha:&alpha)
        }
    }
}

extension Color{
    static func random() -> UIColor{
        return UIColor(
            red: CGFloat.random(in: 0...1),
            green: CGFloat.random(in: 0...1),
            blue: CGFloat.random(in: 0...1),
            alpha: 1)
    }
}

extension UIColor{
    var colorString : String{
        switch self.cgColor {
        case UIColor.systemRed.cgColor: return "red"
        case UIColor.systemGreen.cgColor: return "green"
        case UIColor.systemBlue.cgColor: return "blue"
        case UIColor.systemOrange.cgColor: return "orange"
//        case UIColor.systemYellow.cgColor: return "systemYellow"
        case UIColor.systemPink.cgColor: return "pink"
        case UIColor.systemPurple.cgColor: return "purple"
//        case UIColor.systemTeal.cgColor: return "systemTeal"
        case UIColor.systemIndigo.cgColor: return "indigo"
        default: return ""
            
        }
        
    }
}
