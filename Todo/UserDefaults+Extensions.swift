//
//  UserDefaults+Extensions.swift
//  Todo
//
//  Created by Muhannad Alnemer on 2/22/20.
//  Copyright © 2020 Muhannad Alnemer. All rights reserved.
//

import Foundation
import UIKit
extension UserDefaults {
 func colorForKey(key: String) -> UIColor? {
  var color: UIColor?
  if let colorData = data(forKey: key) {
    
   color = NSKeyedUnarchiver.unarchiveObject(with: colorData) as? UIColor
  }
  return color
 }

 func setColor(color: UIColor?, forKey key: String) {
  var colorData: NSData?
   if let color = color {
    colorData = NSKeyedArchiver.archivedData(withRootObject: color) as NSData?
  }
  set(colorData, forKey: key)
 }

}
